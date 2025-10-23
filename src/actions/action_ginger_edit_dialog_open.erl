%% @author Driebit <tech@driebit.nl>
%% @copyright 2025 Driebit

%% Copyright 2025 Driebit
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(action_ginger_edit_dialog_open).
-author("Driebit <info@driebit.nl>").

%% interface functions
-export([
    render_action/4,
    event/2
]).

-include("zotonic_core/include/zotonic.hrl").

render_action(TriggerId, TargetId, Args, Context) ->
    {PostbackMsgJS, _PickledPostback} = z_render:make_postback(
        {dialog, Args}, click, TriggerId, TargetId, ?MODULE, Context
    ),
    {PostbackMsgJS, Context}.

%% @doc Fill the dialog with the delete confirmation template. The next step will ask to delete the resource
%% @spec event(Event, Context1) -> Context2
event(#postback{message = {dialog, Args}}, Context) ->
    case
        z_convert:to_bool(proplists:get_value(logon_required, Args)) andalso
            z_acl:user(Context) =:= undefined
    of
        true ->
            %% need to log on first
            Continuation = {dialog_open, Args},
            z_render:dialog(
                ?__("You need to log on", Context),
                "_action_dialog_authenticate.tpl",
                [{action, Continuation} | Args],
                Context
            );
        false ->
            Title = proplists:get_value(title, Args, ""),
            {template, Template} = proplists:lookup(template, Args),
            z_render:dialog(Title, Template, Args, Context)
    end.
