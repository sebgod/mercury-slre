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

%----------------------------------------------------------------------------%

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

%----------------------------------------------------------------------------%
%
% Implemtation of server management functions and types in C
%

    % `include_file()' is preferred over `#include', since then linking
    % to the library does not require the presence of the API header
    %
:- pragma foreign_decl("C", include_file("slre.h")).

%----------------------------------------------------------------------------%
:- end_module mercury_slre.
%----------------------------------------------------------------------------%
