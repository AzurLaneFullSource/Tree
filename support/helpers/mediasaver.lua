MediaSaver = {}

local var0 = MediaSaver

function var0.SaveImageWithBytes(arg0, arg1)
	System.IO.File.WriteAllBytes(arg0, arg1)
	YSTool.YSMediaSaver.Inst:SaveImage(arg0)

	if System.IO.File.Exists(arg0) then
		System.IO.File.Delete(arg0)
		warning("del old file path:" .. arg0)
	end
end

function var0.SaveVideoWithPath(arg0)
	YSTool.YSMediaSaver.Inst:SaveVideo(arg0)

	if System.IO.File.Exists(arg0) then
		System.IO.File.Delete(arg0)
		warning("del old file path:" .. arg0)
	end
end
