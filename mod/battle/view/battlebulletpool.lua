ys = ys or {}

local var0_0 = ys
local var1_0 = singletonClass("BattleBulletPool")

var0_0.Battle.BattleBulletPool = var1_0
var1_0.__name = "BattleBulletPool"

function var1_0.Ctor(arg0_1)
	return
end

function var1_0.Init(arg0_2)
	arg0_2._bulletResCache = {}
end

function var1_0.InstantiateBullet(arg0_3, arg1_3, arg2_3)
	if arg0_3._bulletResCache[arg1_3] ~= nil then
		arg2_3(arg0_3._bulletResCache[arg1_3])
	else
		ResourceMgr.Inst:getAssetAsync("Item/" .. arg1_3, arg1_3, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_4)
			assert(arg0_4, "子弹资源加载失败：" .. arg1_3)
			arg2_3(arg0_4)

			arg0_3._bulletResCache[arg1_3] = arg0_4
		end), true, true)
	end
end

function var1_0.Clear(arg0_5)
	arg0_5._bulletResCache = nil
end
