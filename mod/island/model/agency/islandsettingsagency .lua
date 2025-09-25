local var0_0 = class("IslandSettingsAgency ", import(".IslandBaseAgency"))

var0_0.FLAG_TYPES = {
	SHOW_CARD_SOCIAL = 1,
	SHOW_CARD_LABEL = 2
}

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.settingsFlags = {}

	arg0_1:SetFlags(arg1_1.flag_list or {})
end

function var0_0.GetFlagByType(arg0_2, arg1_2)
	return arg0_2.settingsFlags[arg1_2]
end

function var0_0.SetFlags(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg1_3 or {}) do
		arg0_3.settingsFlags[iter1_3.type] = iter1_3.flag
	end
end

return var0_0
