local var0 = class("PublicGuildOfficePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "PublicGuildDonateBluePage"
end

function var0.OnLoaded(arg0)
	arg0.itemList = UIItemList.New(arg0:findTF("frame/donate_panel/list"), arg0:findTF("frame/donate_panel/list/tpl"))
	arg0.cntTxt = arg0:findTF("frame/donate_panel/cnt/Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	arg0.cards = {}

	arg0.itemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateDonateTask(arg2, arg0.displays[arg1 + 1])
		end
	end)
end

function var0.Show(arg0, arg1)
	arg0.guild = arg1

	arg0:Flush()
	var0.super.Show(arg0)
end

function var0.Flush(arg0)
	arg0.displays = arg0.guild:GetDonateTasks()

	arg0.itemList:align(#arg0.displays)
	pg.GuildPaintingMgr:GetInstance():Update("guild_office_blue", Vector3(-737, -171, 0))
end

function var0.UpdateDonateTask(arg0, arg1, arg2)
	local var0 = arg0.guild:GetRemainDonateCnt()
	local var1 = arg0.cards[arg1]

	if not var1 then
		var1 = GuildDonateCard.New(arg1)
		arg0.cards[arg1] = var1
	end

	var1:update(arg2)
	onButton(arg0, var1.commitBtn, function()
		local var0 = var1.dtask
		local var1 = var0:getCommitItem()
		local var2 = Drop.Create(var1)
		local var3 = var1:GetResCntByAward(var1)
		local var4 = var3 < var1[3] and "#FF5C5CFF" or "#92FC63FF"

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_donate_tip", var2:getConfig("name"), var1[3], var3, var4),
			onYes = function()
				arg0:emit(PublicGuildMainMediator.ON_COMMIT, var0.id)
			end
		})
	end, SFX_PANEL)
	setButtonEnabled(var1.commitBtn, var0 > 0)

	arg0.cntTxt.text = i18n("guild_left_donate_cnt", var0)
end

function var0.OnDestroy(arg0)
	return
end

return var0
