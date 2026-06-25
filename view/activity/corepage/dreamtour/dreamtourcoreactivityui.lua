local var0_0 = class("DreamTourCoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "DreamTourCoreActivityUI"
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
				arg0_2:OnToggleName(arg2_3, var0_3)

				if arg0_2.pageDic[var0_3.id] ~= nil then
					setActive(arg2_3:Find("tip"), var0_3:readyToAchieve())
					onToggle(arg0_2, arg2_3, function(arg0_5)
						local var0_5 = arg2_3:Find("off")

						if arg0_5 then
							if var0_2 ~= var0_3.id then
								arg0_2:selectActivity(var0_3)
							end

							var0_2 = var0_3.id
						end

						setActive(var0_5, not arg0_5)
					end, SFX_PANEL)
				end
			end
		end
	end)
	onButton(arg0_2, arg0_2._tf:Find("adapt/TopPage/top/btn_back"), function()
		arg0_2:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
end

function var0_0.ActiveScenarioLayer(arg0_7, arg1_7)
	arg0_7.contextData.activeScenario = arg1_7
end

function var0_0.verifyTabs(arg0_8, arg1_8)
	local var0_8 = arg0_8.activities[arg0_8:getActivityIndex(arg1_8) or arg0_8:getActivityIndex(arg0_8:GetActiveActivity()) or 1]

	if var0_8 == nil then
		return
	end

	local var1_8 = var0_8:getConfig("is_show")
	local var2_8 = arg0_8.tabs:Find(tostring(var1_8))

	if #arg0_8.activities == 1 then
		setActive(arg0_8._tf:Find("adapt/tabs"), false)
	else
		setActive(arg0_8._tf:Find("adapt/tabs"), true)
	end

	triggerToggle(var2_8, true)
end

function var0_0.OnToggleName(arg0_9, arg1_9, arg2_9)
	setText(arg1_9:Find("off/name"), i18n(arg2_9:getConfig("title_res_tag")))
end

return var0_0
