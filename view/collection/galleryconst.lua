GalleryConst = {}

local var0_0 = GalleryConst

var0_0.Version = 3
var0_0.AutoScrollIndex = 41
var0_0.NewCount = 15
var0_0.CardStates = {
	Unlocked = 1
}
var0_0.Sort_Order_Up = 0
var0_0.Sort_Order_Down = 1
var0_0.Filte_Normal_Value = 0
var0_0.Filte_Like_Value = 1
var0_0.Filte_Set_Normal_Value = 0
var0_0.Filte_Set_Value = 1
var0_0.CARD_PATH_PREFIX = "gallerypic/"
var0_0.PIC_PATH_PREFIX = "gallerypic/"

function var0_0.GetGalleryPicPathByID(arg0_1)
	local var0_1 = pg.gallery_config[arg0_1]

	if not var0_1 then
		return nil
	end

	local var1_1 = var0_1.illustration

	return var0_0.PIC_PATH_PREFIX .. var1_1
end

function var0_0.GetGalleryPreviewPicPathByID(arg0_2)
	local var0_2 = pg.gallery_config[arg0_2]

	if not var0_2 then
		return nil
	end

	local var1_2 = var0_2.illustration .. "_t"

	return var0_0.CARD_PATH_PREFIX .. var1_2
end

function var0_0.isGalleryLikeByID(arg0_3)
	local var0_3 = getProxy(AppreciateProxy):getGalleryLikeIDList()

	return table.contains(var0_3, arg0_3)
end

return var0_0
