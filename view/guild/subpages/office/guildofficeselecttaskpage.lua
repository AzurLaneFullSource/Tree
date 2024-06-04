local var0 = class("GuildOfficeSelectTaskPage", import("...base.GuildBasePage"))

function var0.getTargetUI(arg0)
	return "GuildTaskSelectBluePage", "GuildTaskSelectRedPage"
end

function var0.OnLoaded(arg0)
	arg0.uilist = UIItemList.New(arg0:findTF("frame/bg/scrollrect/content"), arg0:findTF("frame/bg/scrollrect/content/tpl"))
	arg0.closeBtn = arg0._tf:Find("frame/title/close")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Close()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2)
	arg0.guild = arg1
	arg0.isAdmin = arg2

	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0._tf:SetAsLastSibling()
	arg0:Update()
end

function var0.Update(arg0)
	local var0 = arg0.guild:getSelectableWeeklyTasks()

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = GuildTaskCard.New(arg2)
			local var1 = var0[arg1 + 1]

			onButton(arg0, var0.acceptBtn, function()
				pg.MsgboxMgr:GetInstance():ShowMsgBox({
					content = i18n("guild_task_selecte_tip", var1:getConfig("name")),
					onYes = function()
						arg0:emit(GuildOfficeMediator.ON_SELECT_TASK, var0.task.id)
						arg0:Close()
					end
				})
			end, SFX_PANEL)
			var0:Update(var1)
		end
	end)
	arg0.uilist:align(#var0)
end

function var0.Close(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.OnDestroy(arg0)
	arg0:Close()
end

return var0
