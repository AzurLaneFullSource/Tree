local var0_0 = class("IslandItemKind")

function var0_0.Type2TagName(arg0_1)
	if not var0_0.TagNames then
		var0_0.TagNames = {
			i18n1("材料"),
			i18n1("道具"),
			i18n1("特殊道具")
		}
	end

	return var0_0.TagNames[arg0_1]
end

return var0_0
