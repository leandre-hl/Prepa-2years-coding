#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include "heapq.h"

//-----------------------------------
// Structures

struct stop {
    char* name;
    double lat, lng;
    bool transfer;
};

typedef struct stop Stop;

struct time {
    int route;
    int stop;
    int time;
    int n_route;
    int n_stop;
    int n_transfer;
};

typedef struct time Time;


//-----------------------------------
// Extract data from files

char* strdup_(char* s) {
    int len = strlen(s);
    char* result = (char*)malloc((len+1)*sizeof(char));
    if (result == NULL) { return NULL; }
    memcpy(result, s, len+1);
    return result;
}

Stop* load_stops(char* filename, int* nb_stops) {
    // Open file
    FILE* f = fopen(filename, "r");
    if (f==NULL) { fprintf(stderr, "Can't open stops file <%s>\n", filename); exit(-1); }

    // First line (number of stops)
    int nb;
    if (fscanf(f, "%d\n", &nb) < 1) { fprintf(stderr, "Error reading stops file <%s> line 1\n", filename); exit(-1); }

    Stop* stops = (Stop*)malloc(nb*sizeof(Stop));
    if (stops==NULL) { fprintf(stderr, "Can't allocate stops array\n"); exit(-1); }

    for (int i=0; i<nb; ++i) {
        int id = -1, transfer;
        Stop s;
        char name[1000];
        if ((fscanf(f, "%d;%lf;%lf;%d;%s\n", &id, &s.lat, &s.lng, &transfer, name)<5) || id<0 || id>=nb) {
            fprintf(stderr, "Error reading stops file <%s> line %d, stop %d (%s)\n", filename, i+2, id, name); exit(-1);
        }
        s.name = strdup_(name);
        s.transfer = transfer != 0;
        stops[i] = s;
    }

    // Close file
    fclose(f);
    *nb_stops = nb;
    return stops;
}

Time* load_times(char* filename, int* nb_times) {
    // Open file
    FILE* f = fopen(filename, "r");
    if (f==NULL) { fprintf(stderr, "Can't open timestamps file <%s>\n", filename); exit(-1); }

    // First line (number of timestamps)
    int nb;
    if (fscanf(f, "%d\n", &nb) < 1) { fprintf(stderr, "Error reading timestamps file <%s> line 1\n", filename); exit(-1); }

    Time* times = (Time*)malloc(nb*sizeof(Time));
    if (times==NULL) { fprintf(stderr, "Can't allocate timestamps array\n"); exit(-1); }

    for (int i=0; i<nb; ++i) {
        if ((fscanf(f, "%d;%d;%d\n", &times[i].route, &times[i].stop, &times[i].time)<3)) {
            fprintf(stderr, "Error reading timestamps file <%s> line %d\n", filename, i+2); exit(-1);
        }
        times[i].n_stop = -1;
        times[i].n_route = -1;
        times[i].n_transfer = -1;
    }

    // Close file
    fclose(f);
    *nb_times = nb;
    return times;
}

//-----------------------------------
// Graph construction

void build_graph(Time times[], int nb_times) {
    for (int i = 0; i<nb_times; i++) {
        if (i < nb_times - 1 && times[i].route == times[i+1].route) {
            times[i].n_route = i+1;
        }
        else {
            times[i].n_route = -1;
        }
        int min = -1;
        for (int j = 0; j<nb_times; j++) {
            if (times[j].stop == times[i].stop && times[j].time > times[i].time && (min == -1 || times[j].time < times[min].time)) {
                min = j;;
            }
        }
        times[i].n_stop = min;
    }
}

int terminus(int id_times, Time times[]) {
    int i;
    for (i = id_times; times[i].n_route != -1; i = times[i].n_route) {}
    return i;
}

void destination(int id_times, Time times[], Stop stops[]) {
    int j = terminus(id_times, times);
    int time = times[j].time - times[id_times].time;
    printf("Terminus : %s\n", stops[times[j].stop].name);
    printf("Nombre d'arrêts : %d\n", j-id_times);
    printf("Temps de trajet : %dh%02d::%02d\n", (time/3600)%24, (time/60)%60, time%60);
}

int next_departure(int id_stop, int time, Time times[], int nb_times) {
    int min = -1;
    for (int i = 0; i< nb_times; i++) {
        if (times[i].stop == id_stop && times[i].time >= time && (min == -1 || times[i].time < times[min].time)) {
            min = i;
        }
    }
    return min;
}

void next_five_departures(int id_stop, int time, Time times[], int nb_times, Stop stops[]) {
    int next_dep = next_departure(id_stop, time, times, nb_times);
    for (int i = 0; i<5 && next_dep != -1; i++) {
        int j = terminus(next_dep, times);
        printf("Heure de départ : %dh%02d | ", (times[next_dep].time/3600)%24, (times[next_dep].time/60)%60);
        printf("Terminus : %s | ", stops[times[j].stop].name);
        printf("Heure d'arrivée : %dh%02d\n", (times[j].time/3600)%24, (times[j].time/60)%60);
        next_dep = times[next_dep].n_stop;
    }
}

void all_destinations(int stop, Time times[], int nb_times, Stop stops[], int nb_stops) {
    printf("Destinations possibles depuis %s :\n", stops[stop].name);
    bool* seen = calloc(nb_stops, sizeof(*seen));
    for (int i = next_departure(stop, 0, times, nb_times); i!= -1; i = times[i].n_stop) {
        int j = terminus(i, times);
        if (!seen[times[j].stop]) {
            printf("%s\n", stops[times[j].stop].name);
            seen[times[j].stop] = true;
        }
    }
    free(seen);
}

void dfs(int id_times, Time times[], Stop stops[], bool seen[], int* count) {
    if (id_times != -1 && !seen[times[id_times].stop]) {
        printf("%s, ", stops[times[id_times].stop].name);
        seen[times[id_times].stop] = true;
        *count += 1;
        dfs(times[id_times].n_route, times, stops, seen, count);
        dfs(times[id_times].n_stop, times, stops, seen, count);
    }
}

void reachable(int stop, int time, Time times[], int nb_times, Stop stops[], int nb_stops) {
    printf("Atteignables :\n");
    bool* seen = calloc(nb_stops, sizeof(*seen));
    int count = 0;
    dfs(next_departure(stop, time, times, nb_times), times, stops, seen, &count);
    free(seen);
    printf("\nNombre : %d\n", count);
}

//-----------------------------------
// Dijkstra exploration 

int* Dijkstra(int index_orig, int dest_stop, Time times[], int nb_times) {
    return NULL; // à compléter
}

//-----------------------------------
// Heuristic calculation

//-----------------------------------
// A* exploration

int* Astar(int index_orig, int dst_stop, Time times[]) {
    return NULL; // à compléter
}

//-----------------------------------
// Routes

void disp_route(int src_stop, int time, int dst_stop, Time times[], int nb_times, Stop stops[]) {
     int index_orig = next_departure(src_stop, time, times, nb_times);
     if (index_orig == -1) { printf("Plus aucun départ\n"); return; }
     int* path = Dijkstra(index_orig, dst_stop, times, nb_times);
     if (path == NULL) { printf("Aucun chemin trouvé\n"); return; }
     int i = 0;
     while (path[i] != -1) {
         Time time = times[path[i]];
         printf("Arrêt %s à %dh%02d\n", stops[time.stop].name, (time.time/3600)%24, (time.time/60)%60);
         i++;
     }
}


//-----------------------------------
// Main file

int main(void) {
    int nb_stops, nb_times;
    Stop* stops = load_stops("stops.dat", &nb_stops);
    Time* times = load_times("times.dat", &nb_times);
    build_graph(times, nb_times);
    //destination(0, times, stops);
    //destination(29, times, stops);
    //destination(59, times, stops);

    next_five_departures(57, (12*60+37)*60, times, nb_times, stops);

    all_destinations(19, times, nb_times, stops, nb_stops);
    all_destinations(26, times, nb_times, stops, nb_stops);

    reachable(18, 22*60+40, times, nb_times, stops, nb_stops);

    return 0;
}
