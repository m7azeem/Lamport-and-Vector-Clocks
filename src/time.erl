%%%-------------------------------------------------------------------
%%% @author m.azeem
%%%
%%% @end
%%% Created : 24. Sep 2020 8:50 PM
%%%-------------------------------------------------------------------
-module(time).
-author("m.azeem").

%% API
-export([zero/0, inc/2, merge/2, leq/2]).

zero() ->
  0.

inc(Name, T) ->
  T + 1.

merge(Ti, Tj) ->
  erlang:max(Ti, Tj).

leq(Ti, Tj) ->
  Ti =< Tj.