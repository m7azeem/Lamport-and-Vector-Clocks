%%%-------------------------------------------------------------------
%%% @author m.azeem
%%%
%%% @end
%%% Created : 24. Sep 2020 8:50 PM
%%%-------------------------------------------------------------------
%% Uses Lamport Clock
-module(time).
-author("m.azeem").

%% API
-export([zero/0, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).

zero() ->
  0.

inc(Name, T) ->
  T + 1.

merge(Ti, Tj) ->
  erlang:max(Ti, Tj).

leq(Ti, Tj) ->
  Ti =< Tj.

clock(Nodes) ->
  lists:foldl(fun(Node, Acc) -> [{Node, zero()} | Acc] end, [], Nodes).

update(Node, Time, Clock) ->
  lists:keyreplace(Node, 1, Clock, {Node, Time}).

safe(Time, Clock) ->
  {_, LowestTime} = hd(lists:keysort(2, Clock)),
  leq(Time, LowestTime).