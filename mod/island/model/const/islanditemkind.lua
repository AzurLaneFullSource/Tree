local var0_0 = class("IslandItemKind")

function var0_0.Type2TagName(arg0_1)
	if not var0_0.TagNames then
		var0_0.TagNames = {
			i18n("island_item_type_res"),
			i18n("island_item_type_consume"),
			i18n("island_item_type_spe")
		}
	end

	return var0_0.TagNames[arg0_1]
end

return var0_0
