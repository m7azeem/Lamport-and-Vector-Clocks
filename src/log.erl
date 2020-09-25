%%%-------------------------------------------------------------------
%%% @author m.azeem
%%%
%%% @end
%%% Created : 24. Sep 2020 10:59 AM
%%%-------------------------------------------------------------------
-module(log).
-author("m.azeem").

%% API
-export([start/1, stop/1]).

start(Nodes) ->
  spawn_link(fun() ->init(Nodes) end).

stop(Log) ->
  Log ! stop.

init(Nodes) ->
  loop(vect:clock(Nodes), []).

loop(Clock, HoldBackQueue) ->
  receive
    {log, From, Time, Msg} ->
      Queue = lists:keysort(2, [{From, Time, Msg} | HoldBackQueue]),
      UpdatedClock = vect:update(From, Time, Clock),
      UpdatedHoldBackQueue = [],
      lists:foreach(fun({FromElement, TimeElement, MsgElement}) ->
        case vect:safe(TimeElement, UpdatedClock) of
          true ->
            log(FromElement, TimeElement, MsgElement);
          false ->
            lists:append([{FromElement, TimeElement, MsgElement}], UpdatedHoldBackQueue)
        end
      end, Queue),
      loop(UpdatedClock, UpdatedHoldBackQueue);
    stop ->
      ok
  end.

log(From, Time, Msg) ->
  io:format("log: ~w ~w ~p~n", [Time, From, Msg]).

