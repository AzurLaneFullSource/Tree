local var0_0 = class("TaskAwardWindow", import(".PtAwardWindow"))

local function var1_0(arg0_1)
	local var0_1 = _.flatten(arg0_1.tasklist)

	local function var1_1(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_1.tasklist) do
			if type(iter1_2) == "table" then
				for iter2_2, iter3_2 in ipairs(iter1_2) do
					if iter3_2 == arg0_2 then
						return iter0_2
					end
				end
			elseif arg0_2 == iter1_2 then
				return iter0_2
			end
		end
	end

	local var2_1 = getProxy(TaskProxy)
	local var3_1

	for iter0_1 = #var0_1, 1, -1 do
		local var4_1 = var0_1[iter0_1]
		local var5_1 = var2_1:getFinishTaskById(var4_1)

		if var5_1 and var5_1:isReceive() then
			var3_1 = var4_1
		end
	end

	var3_1 = var3_1 or var0_1[(arg0_1.index - 1) * 2 + 1]

	arg0_1.UIlist:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = var0_1[arg1_3 + 1]
			local var1_3 = var2_1:getTaskById(var0_3) or var2_1:getFinishTaskById(var0_3) or Task.New({
				id = var0_3
			})
			local var2_3 = GetPerceptualSize(var1_3:getConfig("name"))

			setText(arg2_3:Find("title/Text"), "PHASE " .. var1_1(var0_3))
			setText(arg2_3:Find("target/title"), var1_3:getConfig("name"))
			setText(arg2_3:Find("target/Text"), "")

			if arg2_3:Find("target/icon") then
				if arg0_1.resIcon == "" then
					arg0_1.resIcon = nil
				end

				if arg0_1.resIcon then
					LoadImageSpriteAsync(arg0_1.resIcon, arg2_3:Find("target/icon"), false)
				end

				setActive(arg2_3:Find("target/icon"), arg0_1.resIcon)
				setActive(arg2_3:Find("target/mark"), arg0_1.resIcon)
			end

			local var3_3 = var1_3:getConfig("award_display")[1]
			local var4_3 = {
				type = var3_3[1],
				id = var3_3[2],
				count = var3_3[3]
			}

			updateDrop(arg2_3:Find("award"), var4_3)
			onButton(arg0_1.binder, arg2_3:Find("award"), function()
				arg0_1.binder:emit(BaseUI.ON_DROP, var4_3)
			end, SFX_PANEL)

			local var5_3 = var3_1 and var0_3 < var3_1

			setActive(arg2_3:Find("award/mask"), var1_3:isReceive() or var5_3)
		end
	end)
	arg0_1.UIlist:align(#var0_1)
end

function var0_0.Show(arg0_5, arg1_5)
	arg0_5.tasklist = arg1_5.tasklist
	arg0_5.ptId = arg1_5.ptId
	arg0_5.totalPt = arg1_5.totalPt
	arg0_5.index = arg1_5.index or 1

	arg0_5:updateResIcon(arg1_5.resId, arg1_5.resIcon, arg1_5.type)
	var1_0(arg0_5)

	arg0_5.totalTxt.text = arg0_5.totalPt
	arg0_5.totalTitleTxt.text = i18n("award_window_pt_title")

	setActive(arg0_5._tf, true)
end

return var0_0
