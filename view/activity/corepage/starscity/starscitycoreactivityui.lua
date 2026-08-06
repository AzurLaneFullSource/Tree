local var0_0 = class("StarsCityCoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "StarsCityCoreActivityUI"
end

var0_0.optionsPath = {
	"adapt/TopPage/top/btn_home"
}

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	arg0_2.topPage = arg0_2._tf:Find("adapt/TopPage")
	arg0_2.btnBack = arg0_2.topPage:Find("top/btn_back")

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
				arg0_2:OnToggleName(arg2_3, var0_3)

				if arg0_2.pageDic[var0_3.id] ~= nil then
					setActive(arg2_3:Find("tip"), var0_3:readyToAchieve())
					onToggle(arg0_2, arg2_3, function(arg0_5)
						if arg0_5 then
							if var0_2 ~= var0_3.id then
								arg0_2:selectActivity(var0_3)
							end

							var0_2 = var0_3.id
						end

						setActive(arg2_3:Find("off"), not arg0_5)
						setActive(arg2_3:Find("on"), arg0_5)
					end, SFX_PANEL)
				end
			end
		end
	end)
end

function var0_0.IsImageTgName(arg0_6)
	return true
end

function var0_0.ActiveScenarioLayer(arg0_7, arg1_7)
	arg0_7.contextData.activeScenario = arg1_7
end

return var0_0
