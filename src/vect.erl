%%%-------------------------------------------------------------------
%%% @author m.azeem
%%%
%%% @end
%%% Created : 25. Sep 2020 12:00 AM
%%%-------------------------------------------------------------------
-module(vect).
-author("m.azeem").

%% API
-export([zero/0, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).

zero() ->
  [].

inc(Name, Time) ->
  case lists:keyfind(Name, 1, Time) of
    {Name, NodeTime} ->
      lists:keyreplace(Name, 1, Time, {Name, NodeTime+1});
    false ->
      [{Name, 0} | Time]
  end.

merge([], Tj) ->
  Tj;
merge([{Name, Ti} | Times], Tj) ->
  case lists:keyfind(Name, 1, Tj) of
    {Name, Time} ->
      [{Name, Time} | merge(Times, lists:keydelete(Name, 1, Tj))];
    false ->
      [{Name, Ti} | merge(Times, Tj)]
  end.

leq([],_) ->
  true;
leq([{Name, Ti} | Rest], Tj) ->
  case lists:keyfind(Name, 1, Tj) of
    {Name, Time} ->
      if
        Ti =< Time ->
          true;
        true ->
          false
      end;
    false ->
      leq(Rest, Tj)
  end.

clock(Nodes) ->
  lists:foldl(fun(Node, Acc) -> [{Node, zero()} | Acc] end, [], Nodes).

update(Node, Time, Clock) ->
  case lists:keyfind(Node, 1, Clock) of
    {Node, _} ->
      lists:keyreplace(Node, 1, Clock, {Node, Time});
    false ->
      [{Node, Time} | Clock]
  end.

safe(Time, Clock) ->
  Safe = [],
  lists:foreach(fun({Name, _}) ->
    case lists:keyfind(Name, 1, Clock) of
      {Name, WorkerTime} ->
        lists:append(leq(Time, WorkerTime), Safe);
      false ->
        false
    end
  end, Time),
  length(Safe) == length(Time).