stack(Top, Stack, [Top|Stack]). /*stack for pop and push*/

empty_stack([ ]) .

member_stack(Element, Stack) :-
	member(Element, Stack). /*embedded in the SWI, instead of using the user-defined one*/

push(NewElement, OldStack, NewStack):-
	stack(NewElement, OldStack, NewStack).

pop(Popped, OldStack, NewStack):-
	stack(Popped, NewStack, OldStack).

/*stack implemented*/

add_list_to_stack(List, Stack, Result) :-
	append(List, Stack, Result). /*also embedded in SWI, we made one last section so no need to repeat*/

go(Start, Goal) :-
	empty_stack(Empty_open), /*initializing an empty stack, and it should get back to being null*/
	stack([Start, nil], Empty_open, Opened_Nodes_Stack), /*push Start state*/
	empty_stack(Visited_Nodes_List),
	path(Opened_Nodes_Stack, Visited_Nodes_List, Goal).

path(Opened_Nodes_Stack, _, _) :-
	empty_stack(Opened_Nodes_Stack),
	write("No solution found with these rules").

path(Opened_Nodes_Stack, Visited_Nodes_List, Goal) :-
	stack([State, Parent], _, Opened_Nodes_Stack),
	State = Goal,
	write('A Solution is Found!'), nl,
	printsolution([State, Parent], Visited_Nodes_List).

path(Opened_Nodes_Stack, Visited_Nodes_List, Goal) :-
	stack([State, Parent], Rest_Opened_Nodes_Stack,Opened_Nodes_Stack),
	get_children(State, Rest_Opened_Nodes_Stack, Visited_Nodes_List,Children),
	add_list_to_stack(Children, Rest_Opened_Nodes_Stack,New_Opened_Nodes_Stack),
	union([[State, Parent]], Visited_Nodes_List,New_Visited_Nodes_List),
	path(New_Opened_Nodes_Stack, New_Visited_Nodes_List, Goal), !.

get_children(State, Rest_Opened_Nodes_Stack, Visited_Nodes_List,Children) :-
	bagof(Child, moves(State, Rest_Opened_Nodes_Stack, Visited_Nodes_List, Child), Children).

moves(State, Rest_Opened_Nodes_Stack, Visited_Nodes_List, [Next,State]) :-
	move(State, Next),
	not(member_stack([Next,_], Rest_Opened_Nodes_Stack)),
	not(member_stack([Next,_], Visited_Nodes_List)).

printsolution([State, nil], _) :- write(State), nl.
printsolution([State, Parent], Visited_Nodes_List) :-
	member_stack([Parent, Grandparent], Visited_Nodes_List),
	printsolution([Parent, Grandparent], Visited_Nodes_List),
	write(State), nl.

/*possible moves*/
move(s,b).
move(s,a).
move(b,c).
move(c,g).
move(a,g).
move(a,c).
