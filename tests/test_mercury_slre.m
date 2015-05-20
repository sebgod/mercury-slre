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

:- import_module int.
:- import_module list.
:- import_module string.

%----------------------------------------------------------------------------%

main(!IO) :-
    io.read_line_as_string(RegExRes, !IO),
    ( RegExRes = ok(RegEx),
        match_lines(RegEx, !IO)
    ; RegExRes = error(Error : io.error),
        print_line(stderr_stream, error_message(Error) : string, !IO)
    ; RegExRes = eof,
        print_line(stderr_stream, "premature end of file", !IO)
    ).

:- pred match_lines(string::in, io::di, io::uo) is det.

match_lines(RegEx, !IO) :-
    PrintWithTab = (pred(T::in, !.IO::di, !:IO::uo) is det :-
        io.print("\t", !IO),
        io.print(T, !IO)
    ),
    io.read_line_as_string(TextRes, !IO),
    ( TextRes = ok(Text),
        ( if
            matches(RegEx, Text, match(Captures, ScannedCodeUnits)),
            ScannedCodeUnits >= 0
        then
            print("ok", !IO),
            foldl(PrintWithTab, Captures, !IO),
            nl(!IO)
        else
            true
        ),
        match_lines(RegEx, !IO)
    ; TextRes = error(Error : io.error),
        print_line(stderr_stream, error_message(Error) : string, !IO)
    ; TextRes = eof,
        true
    ).


%----------------------------------------------------------------------------%
:- end_module test_mercury_slre.
%----------------------------------------------------------------------------%
