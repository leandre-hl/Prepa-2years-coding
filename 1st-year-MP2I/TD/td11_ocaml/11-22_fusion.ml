type 'a bst = Nil | Node of 'a bst * 'a * 'a bst

let t1 = Node(
          Node(
            Node(Nil, 1, Nil),
            4,
            Nil
          ),
          5,
          Node(Nil, 6, Nil)
         )

let t2 = Node(
          Node(Nil,2,Nil),
          3,
          Node(
            Node(Nil,4,Nil),
            6,
            Nil
          )
         )

        
let build_stack bst =
  let stack = Stack.create () in
  let rec dfs_infix = function
  | Nil -> ()
  | Node (lc, x, rc) -> dfs_infix lc;
                        Stack.push x stack;
                        dfs_infix rc;
  in dfs_infix bst;
  stack, Stack.length stack

let fusion bst1 bst2 =
  let stack1, n1 = build_stack bst1
  and stack2, n2 = build_stack bst2 in
  let rec build_bst n =
    if n = 0 || Stack.is_empty stack1 && Stack.is_empty stack2
      then Nil
      else
        let right_child = build_bst ((n-1)/2) in
        let root = if Stack.is_empty stack2 || not (Stack.is_empty stack1) && (Stack.top stack1 >= Stack.top stack2)
                      then Stack.pop stack1
                      else Stack.pop stack2 in
        let left_child = build_bst (n/2) in
        Node (left_child, root, right_child)
  in build_bst (n1+n2)