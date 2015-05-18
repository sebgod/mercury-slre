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

:- type match
    --->    match(
                match_captures  :: captures,
                match_length    :: int
            ).

:- type captures == list(string).

    % matches(RegEx, Text, NumberOfCaptures, Match):
    %
    % Fails if no match was found.
    %
:- pred matches(string::in, string::in, int::in, match::out) is semidet.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

:- import_module int.     % for `>='/2
:- import_module require.

matches(RegEx, Text, NumberOfCaptures, Match) :-
    match_impl(RegEx, Text, NumberOfCaptures, Length, CapturesRev),
    ( if Length >= 0 then
        Match = match(Captures, Length),
        Captures = reverse(CapturesRev)
    else if error_code_message(Length, Message) then
        unexpected($file, $pred, Message)
    else
        fail
    ).

%----------------------------------------------------------------------------%
%
% Implementation of functions and types in C
%

    % `include_file()' is preferred over `#include', since then linking
    % to the library does not require the presence of the API header
    %
:- pragma foreign_decl("C", include_file("slre.h")).

    % match_impl(RegEx, Text, NumberOfCaptures, ResultCode, CapturesRev):
    %
:- pred match_impl(string::in, string::in, int::in,
    int::out, captures::out) is det.

:- pragma foreign_proc("C",
    match_impl(RegEx::in, Text::in, NumberOfCaptures::in,
        ScannedCodeUnits::out, CapturesRev::out),
    [promise_pure, may_call_mercury],
"
    struct slre_cap local_captures[NumberOfCaptures];
    ScannedCodeUnits = slre_match(RegEx, Text, strlen(Text),
        local_captures, NumberOfCaptures, 0);

    CapturesRev = MR_list_empty();
    if (ScannedCodeUnits >= 0) {
        int i, len;
        MR_String s;
        for (i = 0; i < NumberOfCaptures &&
                (len = local_captures[i].len) > 0; i++)
        {
            MR_allocate_aligned_string_msg(s, len, MR_ALLOC_ID);
            memcpy(s, local_captures[i].ptr, len);
            s[len] = '\\0';
            CapturesRev = MR_list_cons(s, CapturesRev);
        }
    }
").

    % error_code_message(Code, Message):
    %
    % Succeeds if `Code' represents the error message `Message',
    % fails iff Code represents `no match'.
    %
:- pred error_code_message(int::in, string::out) is semidet.

:- pragma foreign_proc("C",
    error_code_message(Code::in, Message::out),
    [promise_pure, will_not_call_mercury],
"
    SUCCESS_INDICATOR = MR_TRUE;
    switch (Code) {
        case SLRE_NO_MATCH:
            SUCCESS_INDICATOR = MR_FALSE;
            Message = NULL;
        break;
        case SLRE_UNEXPECTED_QUANTIFIER:
            Message = (MR_String)""unexpected quantifier"";
        break;
        case SLRE_UNBALANCED_BRACKETS:
            Message = (MR_String)""unbalanced brackets"";
        break;
        case SLRE_INTERNAL_ERROR:
            Message = (MR_String)""internal error"";
        break;
        case SLRE_INVALID_CHARACTER_SET:
            Message = (MR_String)""invalid_character set"";
        break;
        case SLRE_INVALID_METACHARACTER:
            Message = (MR_String)""invalid metacharacter"";
        break;
        case SLRE_CAPS_ARRAY_TOO_SMALL:
            Message = (MR_String)""capture array too small"";
        break;
        case SLRE_TOO_MANY_BRANCHES:
            Message = (MR_String)""too many branches"";
        break;
        case SLRE_TOO_MANY_BRACKETS:
            Message = (MR_String)""too many brackets"";
        break;
        default:
            Message = (MR_String)""unknown error"";
        break;
    }
").
%----------------------------------------------------------------------------%
:- end_module mercury_slre.
%----------------------------------------------------------------------------%
