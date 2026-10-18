let rot pile k =
  let elem = Stack.pop pile in
  let tmp = Stack.create () in
  for i=1 to k-2 do
    Stack.push (Stack.pop pile) tmp
  done;
  Stack.push elem pile;
  for i=1 to k-2 do
    Stack.push (Stack.pop tmp) pile
  done

let rot2 pile k =
  let tmp = Stack.create () in
  for i=1 to k-2 do
    Stack.push (Stack.pop pile) tmp
  done;
  let elem = Stack.pop pile in
  for i=1 to k-2 do
    Stack.push (Stack.pop tmp) pile
  done;
  Stack.push elem pile


let rev pile k =
  let tmp = Queue.create () in
  while Stack.is_empty pile = false do
    Queue.push (Stack.pop pile) tmp
  done;
  while Queue.is_empty tmp = false do
    Stack.push (Stack.pop tmp) pile
  done
  