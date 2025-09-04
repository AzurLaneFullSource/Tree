local var0_0 = class("IslandSignInGuildListPage", import("..pages.IslandFriendList4GuildPage"))

function var0_0.getUIName(arg0_1)
	return "IslandSignInFriendListUI"
end

function var0_0.GetOpBtns(arg0_2)
	return {
		{
			i18n("island_btn_label_invitation"),
			function(arg0_3)
				arg0_2:emit(IslandMediator.SIGN_IN_INVITATION, {
					arg0_3.id
				})
			end,
			function(arg0_4)
				print(arg0_4)

				return not getProxy(IslandProxy):GetIsland():GetSignInAgency():IsInvited(arg0_4.id)
			end
		},
		{
			i18n("island_btn_label_invitation_already"),
			function(arg0_5)
				return
			end,
			function(arg0_6)
				return (getProxy(IslandProxy):GetIsland():GetSignInAgency():IsInvited(arg0_6.id))
			end
		}
	}
end

return var0_0
