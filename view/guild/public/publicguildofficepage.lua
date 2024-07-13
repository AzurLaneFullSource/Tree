local var0_0 = class("PublicGuildOfficePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PublicGuildDonateBluePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.itemList = UIItemList.New(arg0_2:findTF("frame/donate_panel/list"), arg0_2:findTF("frame/donate_panel/list/tpl"))
	arg0_2.cntTxt = arg0_2:findTF("frame/donate_panel/cnt/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	arg0_3.cards = {}

	arg0_3.itemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateDonateTask(arg2_4, arg0_3.displays[arg1_4 + 1])
		end
	end)
end

function var0_0.Show(arg0_5, arg1_5)
	arg0_5.guild = arg1_5

	arg0_5:Flush()
	var0_0.super.Show(arg0_5)
end

function var0_0.Flush(arg0_6)
	arg0_6.displays = arg0_6.guild:GetDonateTasks()

	arg0_6.itemList:align(#arg0_6.displays)
	pg.GuildPaintingMgr:GetInstance():Update("guild_office_blue", Vector3(-737, -171, 0))
end

function var0_0.UpdateDonateTask(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.guild:GetRemainDonateCnt()
	local var1_7 = arg0_7.cards[arg1_7]

	if not var1_7 then
		var1_7 = GuildDonateCard.New(arg1_7)
		arg0_7.cards[arg1_7] = var1_7
	end

	var1_7:update(arg2_7)
	onButton(arg0_7, var1_7.commitBtn, function()
		local var0_8 = var1_7.dtask
		local var1_8 = var0_8:getCommitItem()
		local var2_8 = Drop.Create(var1_8)
		local var3_8 = var1_7:GetResCntByAward(var1_8)
		local var4_8 = var3_8 < var1_8[3] and "#FF5C5CFF" or "#92FC63FF"

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_donate_tip", var2_8:getConfig("name"), var1_8[3], var3_8, var4_8),
			onYes = function()
				arg0_7:emit(PublicGuildMainMediator.ON_COMMIT, var0_8.id)
			end
		})
	end, SFX_PANEL)
	setButtonEnabled(var1_7.commitBtn, var0_7 > 0)

	arg0_7.cntTxt.text = i18n("guild_left_donate_cnt", var0_7)
end

function var0_0.OnDestroy(arg0_10)
	return
end

return var0_0
