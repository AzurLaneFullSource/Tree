local var0_0 = class("DOACoreActivityUI", import("view.activity.CorePage.MoscowUR.MoscowURCoreActivityUI"))

function var0_0.getUIName(arg0_1)
	return "DOACoreActivityUI"
end

function var0_0.loadingQueue(arg0_2)
	local var0_2 = "play_jiarihangxianshanyaohaibin" .. getProxy(PlayerProxy):getPlayerId()

	if PlayerPrefs.GetInt(var0_2, 0) == 1 then
		return nil
	else
		return function(arg0_3)
			pg.SceneAnimMgr.GetInstance():CommonSceneChange("jiarihangxianshanyaohaibin", function(arg0_4)
				return arg0_3(function()
					PlayerPrefs.SetInt(var0_2, 1)
					existCall(arg0_4)
				end)
			end)
		end
	end
end

function var0_0.OnAnimations(arg0_6, arg1_6, arg2_6)
	SetActive(arg0_6._tf:Find("adapt/logo2"), arg2_6.id == 6032 or arg2_6.id == 6028)
	SetActive(arg0_6._tf:Find("adapt/logo"), arg2_6.id ~= 6032 and arg2_6.id ~= 6028)
	SetActive(arg0_6._tf:Find("left_bg"), arg2_6.id == 6025)
	SetActive(arg0_6._tf:Find("decorate"), arg2_6.id == 6025)
end

function var0_0.OnToggleName(arg0_7, arg1_7, arg2_7)
	return
end

return var0_0
