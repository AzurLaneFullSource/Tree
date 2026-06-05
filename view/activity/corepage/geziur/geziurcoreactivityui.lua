local var0_0 = class("GeZiURCoreActivityUI", import("view.activity.CorePage.Helena.HelenaCoreActivityUI"))
local var1_0 = "#473C2F"
local var2_0 = "#29323B"
local var3_0 = "#B39D83"

function var0_0.getUIName(arg0_1)
	return "GeZiURCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	local var0_2

	arg0_2.tabsList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = underscore.detect(arg0_2.activities, function(arg0_4)
				return tostring(arg0_4:getConfig("is_show")) == arg2_3.name
			end)

			if not var0_3 or var0_3:isEnd() then
				setActive(arg2_3, false)
			elseif not arg0_2.pageDic[var0_3.id] then
				warning(string.format("without page in act:", var0_3.id))
			else
				arg0_2:OnToggleName(arg2_3, var0_3)

				if arg0_2.pageDic[var0_3.id] ~= nil then
					setActive(arg2_3:Find("tip"), var0_3:readyToAchieve())
					onToggle(arg0_2, arg2_3, function(arg0_5)
						if arg0_5 then
							if var0_2 ~= var0_3.id then
								arg0_2:selectActivity(var0_3)
								arg0_2:OnAnimations(arg2_3, var0_3)
							end

							var0_2 = var0_3.id

							if arg0_2:GetActivityClassName(var0_3) == "YidaliV5FramePage" then
								arg0_2:SetColorTab(var1_0)
							elseif arg0_2:GetActivityClassName(var0_3) == "OutPostOmenPage" then
								arg0_2:SetColorTab(var2_0)
							else
								arg0_2:SetColorTab(var3_0)
							end
						end

						setActive(arg2_3:Find("off"), not arg0_5)
						setActive(arg2_3:Find("on"), arg0_5)
					end, SFX_PANEL)
				end
			end
		end
	end)
end

function var0_0.SetColorTab(arg0_6, arg1_6)
	for iter0_6 = 0, arg0_6.tabs.childCount - 1 do
		local var0_6 = arg0_6.tabs:GetChild(iter0_6):Find("off/name")

		if var0_6 then
			setTextColor(var0_6, Color.NewHex(arg1_6))
		end
	end
end

function var0_0.OnToggleName(arg0_7, arg1_7, arg2_7)
	setText(arg1_7:Find("off/name"), i18n(arg2_7:getConfig("title_res_tag")))
	setText(arg1_7:Find("on/name/name"), i18n(arg2_7:getConfig("title_res_tag")))
end

function var0_0.GetActivityClassName(arg0_8, arg1_8)
	if not arg1_8 then
		return nil
	end

	local var0_8 = arg1_8:getConfig("page_info")

	if type(var0_8) == "table" then
		return var0_8.class_name
	end

	return nil
end

return var0_0
