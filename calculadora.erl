-module(calculadora).
-import(string, [strip/3, split/3]).
-export([start/0, soma/3, subtracao/3, multiplicacao/3, divisao/3]).

read_input() -> strip(io:get_line("Expressão: "), right, $\n).

parse(Str) ->
    {ok, Tokens, _} = erl_scan:string(Str ++ "."),
    {ok, [E]} = erl_parse:parse_exprs(Tokens),
    E.

rpn({op, _, What, LS, RS}) ->
    io_lib:format("~s ~s ~s", [rpn(LS), rpn(RS), atom_to_list(What)]);
rpn({integer, _, N}) ->
    io_lib:format("~b", [N]).

p(Str) ->
    Tree = parse(Str),
    lists:flatten(rpn(Tree)).

evaluate_aux(Elem) ->
    if
        Elem == "+" ->
            Stack = get("stack"),
            A = lists:last(Stack),
            ListaA = lists:droplast(Stack),
            B = lists:last(ListaA),
            ListaB = lists:droplast(ListaA),
            Pid_soma = spawn(calculadora, soma, [self(), A, B]),
            receive
              {Pid_soma, Result} ->
                  put("stack", ListaB ++ [Result])
            end;
        Elem == "-" ->
            Stack = get("stack"),
            A = lists:last(Stack),
            ListaA = lists:droplast(Stack),
            B = lists:last(ListaA),
            ListaB = lists:droplast(ListaA),
            Pid_sub = spawn(calculadora, subtracao, [self(), A, B]),
            receive
              {Pid_sub, Result} ->
                  put("stack", ListaB ++ [Result])
            end;
        Elem == "*" ->
            Stack = get("stack"),
            A = lists:last(Stack),
            ListaA = lists:droplast(Stack),
            B = lists:last(ListaA),
            ListaB = lists:droplast(ListaA),
            Pid_multiplicacao = spawn(calculadora, multiplicacao, [self(), A, B]),
            receive
              {Pid_multiplicacao, Result} ->
                  put("stack", ListaB ++ [Result])
            end;
        Elem == "/" ->
            Stack = get("stack"),
            A = lists:last(Stack),
            ListaA = lists:droplast(Stack),
            B = lists:last(ListaA),
            ListaB = lists:droplast(ListaA),
            Pid_div = spawn(calculadora, divisao, [self(), A, B]),
            receive
              {Pid_div, Result} ->
                  put("stack", ListaB ++ [Result])
            end;
        true ->
            {Num, _} = string:to_integer(Elem),
            put("stack", get("stack") ++ [Num])
    end.

evaluate([]) -> ok;
evaluate([H|T]) ->
    evaluate_aux(H),
    evaluate(T).

loop() ->
    put("stack", []),
    ENTRADA = p(read_input()),
    Entrada_f = split(ENTRADA, " ", all),
    evaluate(Entrada_f),
    io:write(get("stack")),
    io:fwrite("\n"),
    loop().

start() ->
    loop().

% processos 
soma(From, A, B) -> 
  io:fwrite("Somando ~p com ~p~n", [A, B]),
  From ! {self(), A + B}.

subtracao(From, A, B) -> 
  io:fwrite("Subtraindo ~p de ~p~n", [B, A]),
  From ! {self(), B - A}.

multiplicacao(From, A, B) ->
  io:fwrite("Multiplicando ~p com ~p~n", [A, B]),
  From ! {self(), A * B}.

divisao(_, _, 0) -> division_by_zero;
divisao(From, A, B) ->
  io:fwrite("Dividindo ~p por ~p~n", [A, B]),
  From ! {self(), B / A}.