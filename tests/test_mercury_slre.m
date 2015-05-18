%----------------------------------------------------------------------------%
% vim: ft=mercury ff=unix ts=4 sw=4 et
%----------------------------------------------------------------------------%
% File: test_mercury_slre.m
% Copyright © 2015 Sebastian Godelet
% Main author: Sebastian Godelet <sebastian.godelet@outlook.com>
% Created on: Mon 18 May 12:48:43 CST 2015
% Stability: low
%----------------------------------------------------------------------------%
% Testing the slre API defined in src/
%----------------------------------------------------------------------------%

:- module test_mercury_slre.

:- interface.

:- import_module io.

%----------------------------------------------------------------------------%

:- pred main(io::di, io::uo) is det.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

:- import_module mercury_slre.

:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.

%----------------------------------------------------------------------------%

main(!IO) :-
    ( if matches("^(\\d+)([a-z]+)$", "abc", 2, match(Captures, _)) then
        print_line("ok", !IO),
        foldl(print_line, Captures, !IO)
    else
        print_line("no match", !IO)
    ).

%----------------------------------------------------------------------------%
:- end_module test_mercury_slre.
%----------------------------------------------------------------------------%
