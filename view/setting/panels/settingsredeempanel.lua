local var0_0 = class("SettingsRedeemPanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsRedeem"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_Redeem")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / KEY"
end

function var0_0.OnInit(arg0_4)
	arg0_4.codeInput = findTF(arg0_4._tf, "voucher")
	arg0_4.placeholder = findTF(arg0_4.codeInput, "Placeholder")
	arg0_4.placeholder:GetComponent(typeof(Text)).text = i18n("exchangecode_use_placeholder")
	arg0_4.achieveBtn = findTF(arg0_4.codeInput, "submit")

	onButton(arg0_4, arg0_4.achieveBtn, function()
		local var0_5 = arg0_4.codeInput:GetComponent(typeof(InputField)).text
		local var1_5
		local var2_5 = pg.gift_key_sp[var0_5]

		if var2_5 and var2_5.key == var0_5 then
			var1_5 = var2_5.group
		elseif #var0_5 > 10 then
			var1_5 = string.sub(var0_5, 1, #var0_5 - 10)
		end

		local var3_5

		if var1_5 and var1_5 ~= "" then
			local var4_5 = pg.gift_group[var1_5]

			if var4_5 then
				local var5_5 = false

				if type(var4_5.active_time) == "string" or type(var4_5.active_time[1][1]) == "table" then
					var5_5 = pg.TimeMgr.GetInstance():inTime(var4_5.active_time)
				else
					var5_5 = pg.TimeMgr.GetInstance():passTime(var4_5.active_time)
				end

				if not var5_5 then
					local var6_5

					if type(var4_5.active_time) ~= "string" then
						if type(var4_5.active_time[1][1]) ~= "table" then
							var6_5 = pg.TimeMgr.GetInstance():passTime(var4_5.active_time)
						else
							var6_5 = pg.TimeMgr.GetInstance():passTime(var4_5.active_time[2])
						end
					end

					if var6_5 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("exchange_code_after_time"))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("exchange_code_before_time"))
					end

					return
				end

				local var7_5 = i18n("exchange_code_tip")
				local var8_5 = ""
				local var9_5 = ""
				local var10_5 = var4_5.drop_list
				local var11_5 = {}

				for iter0_5, iter1_5 in ipairs(var10_5) do
					local var12_5 = Drop.New({
						type = iter1_5[1],
						id = iter1_5[2],
						count = iter1_5[3]
					})

					if iter1_5[1] == DROP_TYPE_SKIN then
						table.insert(var11_5, iter1_5[2])

						var8_5 = i18n("exchange_code_skin_tip") .. var8_5 .. "[" .. var12_5:getName() .. "]*" .. var12_5:getCount()
					else
						var8_5 = var8_5 .. var12_5:getName() .. "*" .. var12_5:getCount()
					end

					if iter0_5 ~= #var10_5 then
						var8_5 = var8_5 .. ","
					end
				end

				local var13_5 = var8_5 .. "\n"

				if var11_5 and #var11_5 > 0 then
					for iter2_5, iter3_5 in ipairs(var11_5) do
						local var14_5 = getProxy(ShipSkinProxy):hasSkin(iter3_5)

						if pg.ship_skin_template[iter3_5] and var14_5 and var9_5 and var9_5 == "" then
							var9_5 = i18n("exchange_code_skin")
						end
					end
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = var7_5 .. var13_5 .. var9_5,
					onYes = function()
						pg.m02:sendNotification(GAME.EXCHANGECODE_USE, {
							key = var0_5
						})
					end,
					onNo = function()
						return
					end
				})
			else
				pg.m02:sendNotification(GAME.EXCHANGECODE_USE, {
					key = var0_5
				})
			end
		else
			pg.m02:sendNotification(GAME.EXCHANGECODE_USE, {
				key = var0_5
			})
		end
	end, SFX_CONFIRM)
	setGray(arg0_4.achieveBtn, getInputText(arg0_4.codeInput) == "")
	onInputChanged(arg0_4, arg0_4.codeInput, function()
		setGray(arg0_4.achieveBtn, getInputText(arg0_4.codeInput) == "")
	end)
	setText(findTF(arg0_4._tf, "voucher/prompt"), i18n("Settings_title_Redeem_input_label"))
	setText(findTF(arg0_4._tf, "voucher/Placeholder"), i18n("Settings_title_Redeem_input_placeholder"))
	setText(findTF(arg0_4._tf, "voucher/submit/Image"), i18n("Settings_title_Redeem_input_submit"))
end

function var0_0.ClearExchangeCode(arg0_9)
	arg0_9.codeInput:GetComponent(typeof(InputField)).text = ""
end

return var0_0
