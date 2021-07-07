# Atividade 011: Programação Concorrente - Calculadora Distribuída

> Caio Martins <br/>
Dayvson Silva <br/>
Jackson Gomes <br/>
Jonatas Travessa <br/>
Lucas Sonoda <br/>


1) Estude esse tutorial: https://learnyousomeerlang.com/designing-a-concurrent-application

2) Crie uma calculadora distribuída em ERLANG onde cada operação matemática é calculada em um processo diferente. O tutorial do item 1 é ESSENCIAL para criar a aplicação de maneira correta


- um processo servidor de calculadora que recebe a expressão matemática, distribui entre os servidores de operações e depois retorna o valor calculado
- um processo servidor para cada operação matemática. deve imprimir o log de cada operação que passar por ele
- defina o protocolo que vc usará para comunicação entre os servidores


Entregável:
- Apresentação explicando:
- o funcionamento da calculadora e como as operações foram distribuídas
- o funcionamento do protocolo




referências:
- https://erlang.org/doc/efficiency_guide/users_guide.html
-
