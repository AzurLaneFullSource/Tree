local var0 = class("TaskAwardWindow", import(".PtAwardWindow"))

local function var1(arg0)
	local var0 = _.flatten(arg0.tasklist)

	local function var1(arg0)
		for iter0, iter1 in ipairs(arg0.tasklist) do
			if type(iter1) == "table" then
				for iter2, iter3 in ipairs(iter1) do
					if iter3 == arg0 then
						return iter0
					end
				end
			elseif arg0 == iter1 then
				return iter0
			end
		end
	end

	local var2 = getProxy(TaskProxy)
	local var3

	for iter0 = #var0, 1, -1 do
		local var4 = var0[iter0]
		local var5 = var2:getFinishTaskById(var4)

		if var5 and var5:isReceive() then
			var3 = var4
		end
	end

	var3 = var3 or var0[(arg0.index - 1) * 2 + 1]

	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = var2:getTaskById(var0) or var2:getFinishTaskById(var0) or Task.New({
				id = var0
			})
			local var2 = GetPerceptualSize(var1:getConfig("name"))

			setText(arg2:Find("title/Text"), "PHASE " .. var1(var0))
			setText(arg2:Find("target/title"), var1:getConfig("name"))
			setText(arg2:Find("target/Text"), "")

			if arg2:Find("target/icon") then
				if arg0.resIcon == "" then
					arg0.resIcon = nil
				end

				if arg0.resIcon then
					LoadImageSpriteAsync(arg0.resIcon, arg2:Find("target/icon"), false)
				end

				setActive(arg2:Find("target/icon"), arg0.resIcon)
				setActive(arg2:Find("target/mark"), arg0.resIcon)
			end

			local var3 = var1:getConfig("award_display")[1]
			local var4 = {
				type = var3[1],
				id = var3[2],
				count = var3[3]
			}

			updateDrop(arg2:Find("award"), var4)
			onButton(arg0.binder, arg2:Find("award"), function()
				arg0.binder:emit(BaseUI.ON_DROP, var4)
			end, SFX_PANEL)

			local var5 = var3 and var0 < var3

			setActive(arg2:Find("award/mask"), var1:isReceive() or var5)
		end
	end)
	arg0.UIlist:align(#var0)
end

function var0.Show(arg0, arg1)
	arg0.tasklist = arg1.tasklist
	arg0.ptId = arg1.ptId
	arg0.totalPt = arg1.totalPt
	arg0.index = arg1.index or 1

	arg0:updateResIcon(arg1.resId, arg1.resIcon, arg1.type)
	var1(arg0)

	arg0.totalTxt.text = arg0.totalPt
	arg0.totalTitleTxt.text = i18n("award_window_pt_title")

	setActive(arg0._tf, true)
end

return var0
