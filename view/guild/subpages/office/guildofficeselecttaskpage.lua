local var0_0 = class("GuildOfficeSelectTaskPage", import("...base.GuildBasePage"))

function var0_0.getTargetUI(arg0_1)
	return "GuildTaskSelectBluePage", "GuildTaskSelectRedPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("frame/bg/scrollrect/content"), arg0_2:findTF("frame/bg/scrollrect/content/tpl"))
	arg0_2.closeBtn = arg0_2._tf:Find("frame/title/close")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Close()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Close()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	arg0_6.guild = arg1_6
	arg0_6.isAdmin = arg2_6

	setActive(arg0_6._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
	arg0_6._tf:SetAsLastSibling()
	arg0_6:Update()
end

function var0_0.Update(arg0_7)
	local var0_7 = arg0_7.guild:getSelectableWeeklyTasks()

	arg0_7.uilist:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = GuildTaskCard.New(arg2_8)
			local var1_8 = var0_7[arg1_8 + 1]

			onButton(arg0_7, var0_8.acceptBtn, function()
				pg.MsgboxMgr:GetInstance():ShowMsgBox({
					content = i18n("guild_task_selecte_tip", var1_8:getConfig("name")),
					onYes = function()
						arg0_7:emit(GuildOfficeMediator.ON_SELECT_TASK, var0_8.task.id)
						arg0_7:Close()
					end
				})
			end, SFX_PANEL)
			var0_8:Update(var1_8)
		end
	end)
	arg0_7.uilist:align(#var0_7)
end

function var0_0.Close(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, arg0_11._parentTf)
	setActive(arg0_11._tf, false)
end

function var0_0.OnDestroy(arg0_12)
	arg0_12:Close()
end

return var0_0
