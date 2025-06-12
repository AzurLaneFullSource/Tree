local var0_0 = class("Dorm3dDancePrepareSubView", import("..Dorm3dGameBaseSubView"))

function var0_0.Init(arg0_1)
	arg0_1.prepareCucoloris = arg0_1._tf:Find("bg/cucoloris")
	arg0_1.songText = arg0_1._tf:Find("bg/title/song")
	arg0_1.performerText = arg0_1._tf:Find("bg/title/performer")
	arg0_1.hintText = arg0_1._tf:Find("bg/hint")
	arg0_1.gameConfig = pg.dorm3d_dance[arg0_1.contextData.groupId]

	setText(arg0_1.songText, arg0_1.gameConfig.song_name)

	local var0_1 = ShipGroup.getDefaultShipNameByGroupID(arg0_1.contextData.groupId)

	setText(arg0_1.performerText, i18n("dorm3d_cafe_minigame1", var0_1))
	setText(arg0_1.hintText, i18n("dorm3d_cafe_minigame2", var0_1))
end

function var0_0.Flush(arg0_2)
	for iter0_2 = 1, #arg0_2.contextData.cucoloris do
		local var0_2 = arg0_2.prepareCucoloris:GetChild(iter0_2 - 1)

		LoadImageSpriteAtlasAsync(arg0_2.contextData.cucoloris[iter0_2]:GetIcon(), "", var0_2:Find("Image"), true)
	end
end

return var0_0
