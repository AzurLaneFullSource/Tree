ys = ys or {}

local var0 = ys
local var1 = singletonClass("BattleBulletPool")

var0.Battle.BattleBulletPool = var1
var1.__name = "BattleBulletPool"

function var1.Ctor(arg0)
	return
end

function var1.Init(arg0)
	arg0._bulletResCache = {}
end

function var1.InstantiateBullet(arg0, arg1, arg2)
	if arg0._bulletResCache[arg1] ~= nil then
		arg2(arg0._bulletResCache[arg1])
	else
		ResourceMgr.Inst:getAssetAsync("Item/" .. arg1, arg1, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			assert(arg0, "子弹资源加载失败：" .. arg1)
			arg2(arg0)

			arg0._bulletResCache[arg1] = arg0
		end), true, true)
	end
end

function var1.Clear(arg0)
	arg0._bulletResCache = nil
end
