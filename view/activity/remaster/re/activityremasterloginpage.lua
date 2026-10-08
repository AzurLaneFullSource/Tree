local var0_0 = class("ActivityRemasterLoginPage", import("view.activity.CorePage.templatePage.CoreLoginSignTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.bgImg = arg0_1.bg:GetComponent(typeof(Image))
	arg0_1.startTm = arg0_1.bg:Find("time"):GetComponent(typeof(Text))
	arg0_1.endTm = arg0_1.bg:Find("time/Text"):GetComponent(typeof(Text))
	arg0_1.timeLabel = arg0_1.bg:Find("time/label"):GetComponent(typeof(Text))
end

function var0_0.OnFirstFlush(arg0_2)
	setActive(arg0_2.item, false)
	arg0_2.itemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventInit then
			local var0_3 = arg2_3:Find("item")
			local var1_3 = Drop.Create(arg0_2.config.front_drops[arg1_3 + 1])

			updateDrop(var0_3, var1_3)
			onButton(arg0_2, arg2_3, function()
				arg0_2:emit(BaseUI.ON_DROP, var1_3)
			end, SFX_PANEL)
			GetImageSpriteFromAtlasAsync("ui/share/light_login_atlas", "DAY" .. arg1_3 + 1, arg2_3:Find("day"), true)
		elseif arg0_3 == UIItemList.EventUpdate then
			local var2_3 = arg1_3 < arg0_2.nday

			setActive(arg2_3:Find("got"), var2_3)
			setActive(arg2_3:Find("get"), var2_3)
			setActive(arg2_3:Find("bg"), not var2_3)
		end
	end)
	arg0_2:UpdateBg()
	arg0_2:UpdateTime()
end

function var0_0.UpdateBg(arg0_5)
	local var0_5 = arg0_5.activity:getConfig("config_client").bg or "1"

	arg0_5.bgImg.sprite = LoadSprite("ActRemasterBg/" .. var0_5)
end

function var0_0.UpdateTime(arg0_6)
	local var0_6, var1_6 = getProxy(ActivityRemasterProxy):InActTime()

	if not var0_6 then
		return
	end

	local var2_6 = pg.activity_re_timer[var1_6]
	local var3_6 = var2_6.timer[2][1][1]
	local var4_6 = var2_6.timer[2][1][2]
	local var5_6 = var2_6.timer[2][1][3]
	local var6_6 = var2_6.timer[3][1][1]
	local var7_6 = var2_6.timer[3][1][2]
	local var8_6 = var2_6.timer[3][1][3]

	arg0_6.startTm.text = var4_6 .. "." .. var5_6
	arg0_6.endTm.text = var7_6 .. "." .. var8_6
	arg0_6.timeLabel.text = i18n("act_remaster_tip_2", "")
end

return var0_0
