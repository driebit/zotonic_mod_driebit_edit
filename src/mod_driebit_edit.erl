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

-module(mod_driebit_edit).
-author("Driebit <info@driebit.nl>").

-mod_title("Driebit Edit Module").
-mod_description("Provides frontend editing and adding dialogs, ported from mod_ginger_edit.").
-mod_prio(200).

-include_lib("zotonic_core/include/zotonic.hrl").

-export([
    is_authorized/2,
    event/2
]).

is_authorized(ReqData, Context) ->
    z_acl:wm_is_authorized(
        use, z_context:get(acl_module, Context, mod_admin), admin_logon, ReqData, Context
    ).

%% overrule mod_admin for using ginger_edit templates
event(
    #postback_notify{
        message = <<"feedback">>,
        trigger = <<"ginger-dialog-connect-find">>,
        target = TargetId
    },
    Context
) ->
    % Find pages matching the search criteria.
    SubjectId = m_rsc:rid(z_context:get_q(<<"subject_id">>, Context), Context),
    ObjectId = m_rsc:rid(z_context:get_q(<<"object_id">>, Context), Context),
    Category = z_context:get_q(<<"find_category">>, Context),
    CatExclude = z_context:get_q(<<"cat_exclude">>, Context),
    Predicate = z_context:get_q(<<"predicate">>, Context, <<>>),
    Text = z_context:get_q(<<"find_text">>, Context),
    Cats =
        case Category of
            <<"p:", Predicate/binary>> ->
                mod_admin:feedback_categories(SubjectId, Predicate, ObjectId, Context);
            <<>> ->
                [];
            Cat ->
                [Cat]
        end,
    Vars =
        [
            {subject_id, SubjectId},
            {cat, Cats},
            {cat_exclude, CatExclude},
            {predicate, Predicate},
            {text, Text}
        ] ++
            case z_context:get_q(<<"find_cg">>, Context) of
                <<>> -> [];
                undefined -> [];
                <<"me">> -> [{creator_id, z_acl:user(Context)}];
                CgId -> [{content_group, m_rsc:rid(CgId, Context)}]
            end,
    z_render:wire(
        [
            {remove_class, [{target, TargetId}, {class, <<"loading">>}]},
            {update, [
                {target, TargetId},
                {template, "_action_ginger_dialog_connect_tab_find_results.tpl"}
                | Vars
            ]}
        ],
        Context
    );
%% @doc Custom version of controller_admin_edit rscform that executes actions instead of redirecting
event(#submit{message = rscform} = Msg, Context) ->
    event(Msg#submit{message = {rscform, []}}, Context);
event(#submit{message = {rscform, Args}}, Context) ->
    Post = z_context:get_q_all_noz(Context),
    Props = controller_admin_edit:filter_props(Post),
    Id = z_convert:to_integer(proplists:get_value(<<"id">>, Props)),
    Props1 = proplists:delete(<<"id">>, Props),
    Props2 = z_notifier:foldl(
        #admin_rscform{
            id = Id,
            is_a = m_rsc:is_a(Id, Context)
        },
        Props1,
        Context),
    case m_rsc:update(Id, Props2, Context) of
        {ok, _} ->
            SuccessActions = proplists:get_all_values(on_success, Args),
            z_render:wire(SuccessActions, Context);
        {error, duplicate_uri} ->
            z_render:growl_error("Error, duplicate uri. Please change the uri.", Context);
        {error, duplicate_page_path} ->
            z_render:growl_error("Error, duplicate page path. Please change the uri.", Context);
        {error, duplicate_name} ->
            z_render:growl_error("Error, duplicate name. Please change the name.", Context);
        {error, eacces} ->
            z_render:growl_error("You don't have permission to edit this page.", Context);
        {error, invalid_query} ->
            z_render:growl_error(
                "Your search query is invalid. Please correct it before saving.", Context
            );
        {error, Message} when is_list(Message); is_binary(Message) ->
            z_render:growl_error(Message, Context);
        {error, Reason} ->
            ?LOG_ERROR(#{
                in => zotonic_mod_driebit_edit,
                text => <<"Resource update error">>,
                result => error,
                reason => Reason,
                rsc_id => Id
            }),
            z_render:growl_error("Something went wrong. Sorry.", Context)
    end.
