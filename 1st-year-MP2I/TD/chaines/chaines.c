
int strlen(char* string) {
  int len;
  for (len=0; string[len] != '\0'; len++) {}
  return len;
}



char* encode (char* message, char* key) {
  int len = strlen(message);

  char* encoded = malloc(sizeof(encoded)*(len+1));

  int j=0;
  for (int i = 0; i<len+1; i++) {
    if ('A' <= message[i] || message[i] <= 'Z') {
      encoded[i] = (message[i] - 'A' + key[j] - 'A') % 26 + 'A';
      
    }
    else {
      encoded[i] = message[i];
    }
  }
  return encoded;
}

