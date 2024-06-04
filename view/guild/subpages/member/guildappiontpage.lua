local var0 = class("GuildAppiontPage", import(".GuildMemberBasePage"))

function var0.getUIName(arg0)
	return "GuildAppiontPage"
end

local var1 = {
	"commander",
	"deputyCommander",
	"picked",
	"normal"
}

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.dutyContainer = arg0:findTF("frame/duty")
	arg0.print = arg0:findTF("frame/prints/print"):GetComponent(typeof(Image))
	arg0.confirmBtn = arg0:findTF("frame/confirm_btn")
	arg0.nameTF = arg0:findTF("frame/info/name/Text", arg0._tf):GetComponent(typeof(Text))
	arg0.iconTF = arg0:findTF("frame/info/shipicon/icon", arg0._tf):GetComponent(typeof(Image))
	arg0.starsTF = arg0:findTF("frame/info/shipicon/stars", arg0._tf)
	arg0.starTF = arg0:findTF("frame/info/shipicon/stars/star", arg0._tf)
	arg0.levelTF = arg0:findTF("frame/info/level/Text", arg0._tf):GetComponent(typeof(Text))
	arg0.circle = arg0:findTF("frame/info/shipicon/frame", arg0._tf)
	arg0.toggles = arg0:findTF("frame/duty"):GetComponent(typeof(ToggleGroup))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.ShouldShow(arg0)
	return arg0.memberVO.id ~= arg0.playerVO.id
end

function var0.OnShow(arg0)
	local var0 = arg0.playerVO
	local var1 = arg0.memberVO
	local var2 = arg0.guildVO
	local var3 = var2:getDutyByMemberId(var0.id)
	local var4 = var2:getEnableDuty(var3, var1.duty)
	local var5 = var2:getAssistantMaxCount()
	local var6 = var2:getAssistantCount()
	local var7

	for iter0, iter1 in ipairs(var1) do
		local var8 = arg0.dutyContainer:Find(iter1)
		local var9 = var8:Find("Text")
		local var10 = false

		if var1.duty == iter0 then
			setText(var9, i18n("guild_duty_tip_1"))

			var10 = true
		elseif not table.contains(var4, iter0) then
			if var5 <= var6 and iter0 == 2 then
				setText(var9, i18n("guild_deputy_commander_cnt_is_full"))
			else
				setText(var9, i18n("guild_duty_tip_2"))
			end

			var10 = true
		end

		setActive(var9, not table.contains(var4, iter0))

		if var3 == GuildConst.DUTY_COMMANDER and iter0 == 2 and not var10 then
			if var5 <= var6 then
				setText(var9, i18n("guild_deputy_commander_cnt_is_full"))
			else
				setText(var9, i18n("guild_deputy_commander_cnt", var6, var5))
			end

			setActive(var9, true)
		end

		setToggleEnabled(var8, table.contains(var4, iter0))
		onToggle(arg0, var8, function(arg0)
			if arg0 then
				var7 = iter0
				arg0.selectedToggle = var8
			end
		end, SFX_PANEL)
	end

	local var11 = arg0.dutyContainer:Find("commander/Image2")

	if var3 == GuildConst.DUTY_COMMANDER and var1.duty > GuildConst.DUTY_DEPUTY_COMMANDER then
		onButton(arg0, var11, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_duty_shoule_be_deputy_commander"))
		end, SFX_PANEL)
	else
		local var12 = var11:GetComponent(typeof(Button))

		if not IsNil(var12) then
			Object.Destroy(var12)
		end
	end

	local var13 = var2:getFaction()

	if var13 == GuildConst.FACTION_TYPE_BLHX then
		arg0.print.color = Color.New(0.423529411764706, 0.631372549019608, 0.956862745098039)
	elseif var13 == GuildConst.FACTION_TYPE_CSZZ then
		arg0.print.color = Color.New(0.956862745098039, 0.443137254901961, 0.427450980392157)
	end

	arg0.nameTF.text = var1.name

	local var14 = AttireFrame.attireFrameRes(var1, var1.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var1.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var14, var14, true, function(arg0)
		if IsNil(arg0._tf) then
			return
		end

		if arg0.circle then
			arg0.name = var14
			findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0, arg0.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var14, var14, arg0)
		end
	end)

	local var15 = pg.ship_data_statistics[var1.icon]
	local var16 = Ship.New({
		configId = var1.icon,
		skin_id = var1.skinId
	})

	LoadSpriteAsync("qicon/" .. var16:getPainting(), function(arg0)
		if not IsNil(arg0.iconTF) then
			arg0.iconTF.sprite = arg0
		end
	end)

	local var17 = arg0.starsTF.childCount

	for iter2 = var17, var15.star - 1 do
		cloneTplTo(arg0.starTF, arg0.starsTF)
	end

	for iter3 = 1, var17 do
		local var18 = arg0.starsTF:GetChild(iter3 - 1)

		setActive(var18, iter3 <= var15.star)
	end

	arg0.levelTF.text = "Lv." .. var1.level

	onButton(arg0, arg0.confirmBtn, function()
		local function var0()
			arg0:emit(GuildMemberMediator.SET_DUTY, var1.id, var7)
			arg0:Hide()
		end

		if var3 == GuildConst.DUTY_COMMANDER and var7 == GuildConst.DUTY_COMMANDER then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("guild_transfer_president_confirm", var1.name),
				onYes = var0
			})
		else
			var0()
		end
	end, SFX_CONFIRM)
end

function var0.Hide(arg0)
	arg0.toggles:SetAllTogglesOff()
	var0.super.Hide(arg0)
end

return var0
