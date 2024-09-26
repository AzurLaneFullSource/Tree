MediaSaver = {}

local var0_0 = MediaSaver

function var0_0.SaveImageWithBytes(arg0_1, arg1_1)
	System.IO.File.WriteAllBytes(arg0_1, arg1_1)

	if CameraHelper.IsIOS() then
		local var0_1 = pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t")
		local var1_1 = "azur" .. var0_1.year .. var0_1.month .. var0_1.day .. var0_1.hour .. var0_1.min .. var0_1.sec .. ".png"

		YARecorder.Inst:WritePictureToAlbum(var1_1, arg1_1)
	else
		YSTool.YSMediaSaver.Inst:SaveImage(arg0_1)
	end

	if System.IO.File.Exists(arg0_1) then
		System.IO.File.Delete(arg0_1)
		warning("del old file path:" .. arg0_1)
	end
end

function var0_0.SaveVideoWithPath(arg0_2)
	YSTool.YSMediaSaver.Inst:SaveVideo(arg0_2)

	if System.IO.File.Exists(arg0_2) then
		System.IO.File.Delete(arg0_2)
		warning("del old file path:" .. arg0_2)
	end
end
