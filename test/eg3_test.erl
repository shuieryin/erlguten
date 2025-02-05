%%==========================================================================
%% Copyright (C) 2003 Joe Armstrong
%%
%% Permission is hereby granted, free of charge, to any person obtaining a
%% copy of this software and associated documentation files (the
%% "Software"), to deal in the Software without restriction, including
%% without limitation the rights to use, copy, modify, merge, publish,
%% distribute, sublicense, and/or sell copies of the Software, and to permit
%% persons to whom the Software is furnished to do so, subject to the
%% following conditions:
%% 
%% The above copyright notice and this permission notice shall be included
%% in all copies or substantial portions of the Software.
%% 
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
%% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
%% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
%% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
%% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
%% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
%% USE OR OTHER DEALINGS IN THE SOFTWARE.
%%
%% Author: Joe Armstrong <joe@sics.se>
%% Purpose: Test cases 
%%==========================================================================

-module(eg3_test).
-include("../include/eg.hrl").
-include_lib("eunit/include/eunit.hrl").
-define(IMAGE_DIR, "./test/images/").
-import(eg_pdf, [picas/1]).

%% ============================================================================

box(PDF, Color, X, Y, W, H) ->
    eg_pdf:set_fill_color(PDF, Color),
    eg_pdf:rectangle(PDF, {X, Y}, {W, H}),
    eg_pdf:path(PDF, fill),
    eg_pdf:set_fill_color(PDF, black).


run_test() ->
    ?debugMsg("Begin Test"),
    PDF = eg_pdf:new(),
    eg_pdf:set_pagesize(PDF, a4),
    eg_pdf:set_page(PDF, 1),
    eg_pdf_lib:showGrid(PDF, a4),
    PtSize24 = 24,
    TagMap24 = eg_xml2richText:default_tagMap(PtSize24),
    box(PDF, moccasin, 50, 300, 225, 350),
    eg_block:block(PDF, gold, xml(title), 20, 830, picas(66), PtSize24, 24, 1, justified, TagMap24),

    PtSize14 = 14,
    TagMap14 = eg_xml2richText:default_tagMap(PtSize14),
    eg_block:block(PDF, xml(simple), 60, 650, picas(35), PtSize14, 16, 5, justified, TagMap14),
    eg_block:block(PDF, xml(simple), 60, 560, picas(30), PtSize14, 16, 5, justified, TagMap14),
    eg_block:block(PDF, xml(romanAndCourier1), 60, 360, picas(35), PtSize14, 16, 7, justified, TagMap14),

    PtSize12 = 12,
    TagMap12 = eg_xml2richText:default_tagMap(PtSize12),
    eg_block:block(PDF, palegreen, xml(complex), 400, 600, picas(26), PtSize12, 14, 22, justified, TagMap12),
    eg_block:block(PDF, xml(5), 60, 450, picas(35), PtSize12, 14, 6, justified, TagMap12),

    PtSize18 = 18,
    TagMap18 = eg_xml2richText:default_tagMap(PtSize18),
    eg_block:block(PDF, whitesmoke, xml(two), 300, 760, picas(44), PtSize18, 20, 3, justified, TagMap18),

    PtSize8 = 8,
    TagMap8 = eg_xml2richText:default_tagMap(PtSize8),
    eg_block:block(PDF, azure, xml(narrow), 280, 650, picas(16), PtSize8, 10, 38, justified, TagMap8),

    eg_pdf:image(PDF, ?IMAGE_DIR ++ 'joenew.jpg', {50, 650}, {width, 200}),
    {Serialised, _PageNo} = eg_pdf:export(PDF),
    file:write_file("./ebin/eg_test3.pdf", [Serialised]),
    eg_pdf:delete(PDF).


%%----------------------------------------------------------------------
%% test data sets

%% Here are some widths
%% Times Roman A = 722
%% space = 250
%% a = 444
%% b = 500
%% c = 444
%% W = 944

xml(1) ->
    "<p>aaa aaa aaa aaa bbb ccc ddd eee aaa ddd ss aaa aaa aaa 
        bbb bbb bbb bbb bbb bbb bbb ccc ddd
     </p>";
xml(narrow) ->
    "<p>This is a long narrow box set in Times-Roman. Times-Roman was
designed for printing long and narrow newspaper columns. It actually looks    
pretty horrid if set in wide measures. This is set narrow and tight. The 
really catastrophic thing about Times-Roman is that is is probably the
most commonly used typeface, despite the fact it in manifestly
unsuitable for the purpose it is being used for. Using narrow columns
you can cram in loads of virtually unreadable data - no body will thank
you, apart from environmentalists, who, I suppose will be pleased at the
number of trees which are being saved.</p>";
xml(simple) ->
    "<p>This is normal text, with no emphasised code, 
the next example will be more complicated. This example
is just simple text. In the next example I will show some
text with emphasis.</p>";
xml(two) ->
    "<p>This is normal text, with a small
amount of <em>emphasised</em> text.
This example only has two typefaces.</p>";
xml(romanAndCourier1) ->
    "<p>This is normal text, with a small
amount of <code>courier</code> text.
This example only has two typefaces.</p>";
xml(complex) ->
    "<p>This is normal text, set 5 picas wide in 12/14 Times Roman.
I even allow some <em>emphasised term,</em> set in Times-Italic. The TeX
hyphenation algorithm is also implemented.
I have also some <em>cursive text</em> and an example of
an Erlang term. The term <code>{person, \"Joe\"}</code> is an Erlang term.
The variable <code>X</code>, was immediately followed by
a comma. The justification algorithm does proper <em>kerning</em>,
which is more than <em>Microsoft Word</em> can do. AWAY again is
correctly kerned! Erlang terms <code>{like, this}</code>
are typeset in <em>courier.</em></p>";
xml(4) ->
    "<p>This is Times Roman.</p>";
xml(5) -> "<p>is <red>AWAY</red> correctly kerned? Erlang terms
    <code>{like, this}</code>are typeset in <em>courier.</em>
   The <red>red terms are typeset in ZapfChancery-MediumItalic.</red>
   Then I can set <blue>blue</blue> terms as well.</p>";
xml(title) ->
    "<p>This page tests justification routines</p>".

norm() -> "(This is normal text, with some **emphasised code**, I have
    also some *cursive text* and an example of and Erlang term. The
    term <{person, \"Joe\"}> is an Erlang term.  The variable <X>, was
    immediately followed by a comma.)".


