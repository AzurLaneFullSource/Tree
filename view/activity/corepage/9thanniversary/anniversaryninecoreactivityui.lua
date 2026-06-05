local var0_0 = class("AnniversaryNineCoreActivityUI", import("view.activity.CorePage.CoreAdaptActivityMainScene"))
local var1_0 = "#a6beb7"
local var2_0 = "#584E45"

function var0_0.getUIName(arg0_1)
	return "AnniversaryNineCoreActivityUI"
end

var0_0.optionsPath = {
	"adapt/TopPage/top/btn_home"
}

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	arg0_2.topPage = arg0_2._tf:Find("adapt/TopPage")

	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("HelenaCoreActivity_title"))
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("HelenaCoreActivity_title2"))

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
				setText(arg2_3:Find("off/name"), arg0_2:GetButtonNameText(var0_3))
				setText(arg2_3:Find("on/name"), arg0_2:GetButtonNameText(var0_3))

				if arg0_2.pageDic[var0_3.id] ~= nil then
					local var1_3 = arg0_2.pageDic[var0_3.id]
					local var2_3 = arg2_3:Find("tip")
					local var3_3 = var1_3:IsShowReminder()

					setActive(var2_3, var0_3:readyToAchieve())
					onToggle(arg0_2, arg2_3, function(arg0_5)
						if arg0_5 then
							arg0_2:selectActivity(var0_3)

							if var0_2 ~= var0_3.id then
								arg0_2:OnClickBtn(arg2_3, var0_3.id)
							end

							var0_2 = var0_3.id

							local var0_5 = arg0_2:GetActivityClassName(var0_3)

							if var0_5 == "AnniversaryNineHwahJahSkinPage" or var0_5 == "AnniversaryNineEvertsenSkinPage" then
								arg0_2:SetColorTab(var1_0)
							else
								arg0_2:SetColorTab(var2_0)
							end
						end
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

function var0_0.GetActivityClassName(arg0_7, arg1_7)
	if not arg1_7 then
		return nil
	end

	local var0_7 = arg1_7:getConfig("page_info")

	if type(var0_7) == "table" then
		return var0_7.class_name
	end

	return nil
end

function var0_0.GetButtonNameText(arg0_8, arg1_8)
	return i18n(string.format(arg1_8:getConfig("title_res_tag")))
end

return var0_0
