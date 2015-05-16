%----------------------------------------------------------------------------%
% vim: ft=mercury ff=unix ts=4 sw=4 et
%----------------------------------------------------------------------------%
% File: mercury_slre.m
% Copyright © 2015 Sebastian Godelet
% Main author: Sebastian Godelet <sebastian.godelet@outlook.com>
% Created on: Thu 18 Dec 17:38:25 CST 2014
% Stability: low
%----------------------------------------------------------------------------%
% API to access the lightwight slre HTTP(S) web-server.
% The open-source (GPLv2) version is used for this library, i.e. that
% means that this library is also licensed under the GPLv2.
% c.f.: https://github.com/cesanta/slre
%
%----------------------------------------------------------------------------%

:- module mercury_slre.

:- interface.

:- import_module list.

%----------------------------------------------------------------------------%

:- type captures == list(string).

:- type result
    --->    ok(captures)
    ;       error(match_error).

:- type match_error
    --->    no_match
    ;       unexpected_quantifier
    ;       unbalanced_brackets
    ;       internal_error
    ;       invalid_character_set
    ;       invalid_metacharacter
    ;       caps_array_too_small
    ;       too_many_branches
    ;       too_many_brackets.

    % match(RegEx, Text, NumberOfCaptures) = Result.
    %
:- func match(string, string, int) = result.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

match(RegEx, Text, NumberOfCaptures) = Result :-
    slre_match(RegEx, Text, NumberOfCaptures, ResultCode),
    Result = ok([]).

%----------------------------------------------------------------------------%
%
% Implemtation of functions and types in C
%

    % `include_file()' is preferred over `#include', since then linking
    % to the library does not require the presence of the API header
    %
:- pragma foreign_decl("C", include_file("slre.h")).

:- pred slre_match(string::in, string::in, NumberOfMatches::in,
    int::out) is det.

:- pragma foreign_proc("C",
    slre_match(RegEx::in, Text::in, NumberOfCaptures::in, ResultCode::out),
    [promise_pure, will_not_call_mercury],
"
    struct slre_cap captures[NumberOfCaptures];
    ResultCode = slre_match(RegEx, Text, strlen(Text), captures,
        NumberOfCaptures, 0);
").

%----------------------------------------------------------------------------%
:- end_module mercury_slre.
%----------------------------------------------------------------------------%
