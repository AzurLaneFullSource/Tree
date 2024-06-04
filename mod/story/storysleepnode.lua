ys = ys or {}
ys.Story.StorySleepNode = class("StorySleepNode", ys.ISeqNode)

local var0 = ys.Story.StorySleepNode

pg.NodeMgr.RigisterNode("StorySleep", var0)

function var0.Ctor(arg0, arg1, arg2)
	arg0._time = arg2[2]
end

function var0.Init(arg0)
	arg0._end = os.time() + arg0._time
end

function var0.Update(arg0)
	if os.time() >= arg0._end then
		arg0:Dispose()
	end
end
