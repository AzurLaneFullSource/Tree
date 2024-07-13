local var0_0 = class("GuildAppiontPage", import(".GuildMemberBasePage"))

function var0_0.getUIName(arg0_1)
	return "GuildAppiontPage"
end

local var1_0 = {
	"commander",
	"deputyCommander",
	"picked",
	"normal"
}

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.dutyContainer = arg0_2:findTF("frame/duty")
	arg0_2.print = arg0_2:findTF("frame/prints/print"):GetComponent(typeof(Image))
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm_btn")
	arg0_2.nameTF = arg0_2:findTF("frame/info/name/Text", arg0_2._tf):GetComponent(typeof(Text))
	arg0_2.iconTF = arg0_2:findTF("frame/info/shipicon/icon", arg0_2._tf):GetComponent(typeof(Image))
	arg0_2.starsTF = arg0_2:findTF("frame/info/shipicon/stars", arg0_2._tf)
	arg0_2.starTF = arg0_2:findTF("frame/info/shipicon/stars/star", arg0_2._tf)
	arg0_2.levelTF = arg0_2:findTF("frame/info/level/Text", arg0_2._tf):GetComponent(typeof(Text))
	arg0_2.circle = arg0_2:findTF("frame/info/shipicon/frame", arg0_2._tf)
	arg0_2.toggles = arg0_2:findTF("frame/duty"):GetComponent(typeof(ToggleGroup))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.ShouldShow(arg0_5)
	return arg0_5.memberVO.id ~= arg0_5.playerVO.id
end

function var0_0.OnShow(arg0_6)
	local var0_6 = arg0_6.playerVO
	local var1_6 = arg0_6.memberVO
	local var2_6 = arg0_6.guildVO
	local var3_6 = var2_6:getDutyByMemberId(var0_6.id)
	local var4_6 = var2_6:getEnableDuty(var3_6, var1_6.duty)
	local var5_6 = var2_6:getAssistantMaxCount()
	local var6_6 = var2_6:getAssistantCount()
	local var7_6

	for iter0_6, iter1_6 in ipairs(var1_0) do
		local var8_6 = arg0_6.dutyContainer:Find(iter1_6)
		local var9_6 = var8_6:Find("Text")
		local var10_6 = false

		if var1_6.duty == iter0_6 then
			setText(var9_6, i18n("guild_duty_tip_1"))

			var10_6 = true
		elseif not table.contains(var4_6, iter0_6) then
			if var5_6 <= var6_6 and iter0_6 == 2 then
				setText(var9_6, i18n("guild_deputy_commander_cnt_is_full"))
			else
				setText(var9_6, i18n("guild_duty_tip_2"))
			end

			var10_6 = true
		end

		setActive(var9_6, not table.contains(var4_6, iter0_6))

		if var3_6 == GuildConst.DUTY_COMMANDER and iter0_6 == 2 and not var10_6 then
			if var5_6 <= var6_6 then
				setText(var9_6, i18n("guild_deputy_commander_cnt_is_full"))
			else
				setText(var9_6, i18n("guild_deputy_commander_cnt", var6_6, var5_6))
			end

			setActive(var9_6, true)
		end

		setToggleEnabled(var8_6, table.contains(var4_6, iter0_6))
		onToggle(arg0_6, var8_6, function(arg0_7)
			if arg0_7 then
				var7_6 = iter0_6
				arg0_6.selectedToggle = var8_6
			end
		end, SFX_PANEL)
	end

	local var11_6 = arg0_6.dutyContainer:Find("commander/Image2")

	if var3_6 == GuildConst.DUTY_COMMANDER and var1_6.duty > GuildConst.DUTY_DEPUTY_COMMANDER then
		onButton(arg0_6, var11_6, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_duty_shoule_be_deputy_commander"))
		end, SFX_PANEL)
	else
		local var12_6 = var11_6:GetComponent(typeof(Button))

		if not IsNil(var12_6) then
			Object.Destroy(var12_6)
		end
	end

	local var13_6 = var2_6:getFaction()

	if var13_6 == GuildConst.FACTION_TYPE_BLHX then
		arg0_6.print.color = Color.New(0.423529411764706, 0.631372549019608, 0.956862745098039)
	elseif var13_6 == GuildConst.FACTION_TYPE_CSZZ then
		arg0_6.print.color = Color.New(0.956862745098039, 0.443137254901961, 0.427450980392157)
	end

	arg0_6.nameTF.text = var1_6.name

	local var14_6 = AttireFrame.attireFrameRes(var1_6, var1_6.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var1_6.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var14_6, var14_6, true, function(arg0_9)
		if IsNil(arg0_6._tf) then
			return
		end

		if arg0_6.circle then
			arg0_9.name = var14_6
			findTF(arg0_9.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_9, arg0_6.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var14_6, var14_6, arg0_9)
		end
	end)

	local var15_6 = pg.ship_data_statistics[var1_6.icon]
	local var16_6 = Ship.New({
		configId = var1_6.icon,
		skin_id = var1_6.skinId
	})

	LoadSpriteAsync("qicon/" .. var16_6:getPainting(), function(arg0_10)
		if not IsNil(arg0_6.iconTF) then
			arg0_6.iconTF.sprite = arg0_10
		end
	end)

	local var17_6 = arg0_6.starsTF.childCount

	for iter2_6 = var17_6, var15_6.star - 1 do
		cloneTplTo(arg0_6.starTF, arg0_6.starsTF)
	end

	for iter3_6 = 1, var17_6 do
		local var18_6 = arg0_6.starsTF:GetChild(iter3_6 - 1)

		setActive(var18_6, iter3_6 <= var15_6.star)
	end

	arg0_6.levelTF.text = "Lv." .. var1_6.level

	onButton(arg0_6, arg0_6.confirmBtn, function()
		local function var0_11()
			arg0_6:emit(GuildMemberMediator.SET_DUTY, var1_6.id, var7_6)
			arg0_6:Hide()
		end

		if var3_6 == GuildConst.DUTY_COMMANDER and var7_6 == GuildConst.DUTY_COMMANDER then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("guild_transfer_president_confirm", var1_6.name),
				onYes = var0_11
			})
		else
			var0_11()
		end
	end, SFX_CONFIRM)
end

function var0_0.Hide(arg0_13)
	arg0_13.toggles:SetAllTogglesOff()
	var0_0.super.Hide(arg0_13)
end

return var0_0
