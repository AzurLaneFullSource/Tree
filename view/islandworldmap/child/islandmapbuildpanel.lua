local var0_0 = class("IslandMapBuildPanel")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1

	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/go"), function()
		arg0_1:onClickGo()
	end, SFX_CONFIRM)
	LoadImageSpriteAtlasAsync(IslandWorldMapConst.build_panel_pic_path, "build_1", findTF(arg0_1._tf, "ad/buildPic"), false)
end

function var0_0.setData(arg0_3, arg1_3)
	arg0_3.buildType = arg1_3
end

function var0_0.onClickGo(arg0_4)
	return
end

function var0_0.dispose(arg0_5)
	return
end

function var0_0.setActive(arg0_6, arg1_6)
	setActive(arg0_6._tf, arg1_6)
end

return var0_0
