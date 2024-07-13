ys = ys or {}
ys.Story.StorySleepNode = class("StorySleepNode", ys.ISeqNode)

local var0_0 = ys.Story.StorySleepNode

pg.NodeMgr.RigisterNode("StorySleep", var0_0)

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._time = arg2_1[2]
end

function var0_0.Init(arg0_2)
	arg0_2._end = os.time() + arg0_2._time
end

function var0_0.Update(arg0_3)
	if os.time() >= arg0_3._end then
		arg0_3:Dispose()
	end
end
