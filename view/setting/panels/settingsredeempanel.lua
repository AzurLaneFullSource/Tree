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

		if #var0_5 > 10 then
			var1_5 = string.sub(var0_5, 1, #var0_5 - 10)
		end

		local var2_5

		if var1_5 and var1_5 ~= "" then
			local var3_5 = pg.gift_group[var1_5]

			if var3_5 then
				local var4_5 = false

				if type(var3_5.active_time) == "string" or type(var3_5.active_time[1][1]) == "table" then
					var4_5 = pg.TimeMgr.GetInstance():inTime(var3_5.active_time)
				else
					var4_5 = pg.TimeMgr.GetInstance():passTime(var3_5.active_time)
				end

				if not var4_5 then
					local var5_5

					if type(var3_5.active_time) ~= "string" then
						if type(var3_5.active_time[1][1]) ~= "table" then
							var5_5 = pg.TimeMgr.GetInstance():passTime(var3_5.active_time)
						else
							var5_5 = pg.TimeMgr.GetInstance():passTime(var3_5.active_time[2])
						end
					end

					if var5_5 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("exchange_code_after_time"))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("exchange_code_before_time"))
					end

					return
				end

				local var6_5 = i18n("exchange_code_tip")
				local var7_5 = ""
				local var8_5 = ""
				local var9_5 = var3_5.drop_list
				local var10_5 = {}

				for iter0_5, iter1_5 in ipairs(var9_5) do
					local var11_5 = Drop.New({
						type = iter1_5[1],
						id = iter1_5[2],
						count = iter1_5[3]
					})

					if iter1_5[1] == DROP_TYPE_SKIN then
						table.insert(var10_5, iter1_5[2])

						var7_5 = i18n("exchange_code_skin_tip") .. var7_5 .. "[" .. var11_5:getName() .. "]*" .. var11_5:getCount()
					else
						var7_5 = var7_5 .. var11_5:getName() .. "*" .. var11_5:getCount()
					end

					if iter0_5 ~= #var9_5 then
						var7_5 = var7_5 .. ","
					end
				end

				local var12_5 = var7_5 .. "\n"

				if var10_5 and #var10_5 > 0 then
					for iter2_5, iter3_5 in ipairs(var10_5) do
						local var13_5 = getProxy(ShipSkinProxy):hasSkin(iter3_5)

						if pg.ship_skin_template[iter3_5] and var13_5 and var8_5 and var8_5 == "" then
							var8_5 = i18n("exchange_code_skin")
						end
					end
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = var6_5 .. var12_5 .. var8_5,
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
