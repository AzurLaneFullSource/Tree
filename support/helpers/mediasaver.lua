MediaSaver = {}

local var0_0 = MediaSaver

function var0_0.SaveImageWithBytes(arg0_1, arg1_1)
	System.IO.File.WriteAllBytes(arg0_1, arg1_1)
	YSTool.YSMediaSaver.Inst:SaveImage(arg0_1)

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
