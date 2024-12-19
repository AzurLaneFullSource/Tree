return {
	map_id = 10001,
	id = 1886003,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 300,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-80,
				20,
				90,
				70
			},
			playerArea = {
				-80,
				20,
				45,
				68
			},
			enemyArea = {},
			fleetCorrdinate = {
				-80,
				0,
				75
			},
			waves = {
				{
					triggerType = 1,
					waveIndex = 100,
					preWaves = {},
					triggerParams = {
						timeout = 0.5
					}
				},
				{
					triggerType = 3,
					waveIndex = 501,
					preWaves = {
						100
					},
					triggerParams = {
						id = "XINGGUANGXIADEYUHUI18-1"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						501
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16696008,
							delay = 0,
							sickness = 1,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 100,
								icon = "",
								hideBarNum = true
							},
							buffList = {
								201210,
								201211,
								200825,
								201192,
								205005,
								200607
							},
							phase = {
								{
									switchParam = 1,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20006
								},
								{
									switchType = 1,
									switchTo = 2,
									index = 1,
									switchParam = 9,
									setAI = 20006,
									addWeapon = {
										3234003,
										3234004
									}
								},
								{
									index = 2,
									switchParam = 2,
									switchTo = 3,
									switchType = 1,
									addBuff = {
										201212
									},
									removeWeapon = {
										3234003,
										3234004
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 7,
									addWeapon = {
										3234005,
										3234007
									}
								},
								{
									index = 4,
									switchParam = 8,
									switchTo = 5,
									switchType = 1,
									addBuff = {
										201218
									},
									addWeapon = {
										3234006
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 1,
									removeWeapon = {
										3234005,
										3234006,
										3234007
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 2,
									addWeapon = {
										3234010
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 6,
									addWeapon = {
										3234011,
										3234014
									}
								},
								{
									index = 8,
									switchParam = 4,
									switchTo = 9,
									switchType = 1,
									addWeapon = {
										3234012,
										3234015
									},
									removeWeapon = {
										3234014
									}
								},
								{
									index = 9,
									switchParam = 5.5,
									switchTo = 10,
									switchType = 1,
									addWeapon = {
										3234013
									},
									removeWeapon = {}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 11,
									switchParam = 0.5,
									removeWeapon = {
										3234012,
										3234013
									}
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 12,
									switchParam = 6,
									addWeapon = {
										3234012,
										3234013,
										3234014
									}
								},
								{
									index = 12,
									switchType = 1,
									switchTo = 1,
									switchParam = 2,
									removeWeapon = {
										3234010,
										3234011,
										3234012,
										3234013,
										3234014,
										3234015
									}
								}
							}
						}
					}
				},
				{
					triggerType = 1,
					waveIndex = 102,
					preWaves = {
						501
					},
					triggerParams = {
						timeout = 17
					}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 502,
					preWaves = {
						102
					},
					triggerParams = {
						id = "XINGGUANGXIADEYUHUI18-2"
					}
				},
				{
					triggerType = 1,
					waveIndex = 103,
					preWaves = {
						502
					},
					triggerParams = {
						timeout = 17
					}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 503,
					preWaves = {
						103
					},
					triggerParams = {
						id = "XINGGUANGXIADEYUHUI18-3"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 504,
					conditionType = 1,
					preWaves = {
						503
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16694303,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								50
							},
							buffList = {},
							phase = {
								{
									switchParam = 0.3,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20006
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 1,
									addWeapon = {
										3236007
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 0,
									switchParam = 300,
									addBuff = {
										201217
									}
								}
							}
						}
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900479,
				configId = 900479,
				skinId = 402110,
				id = 1,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 300,
					air = 0,
					antiaircraft = 200,
					torpedo = 300,
					durability = 50000,
					reload = 200,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 150710,
						level = 10
					},
					{
						id = 150720,
						level = 10
					},
					{
						id = 30402,
						level = 10
					},
					{
						id = 201216,
						level = 2
					}
				}
			},
			{
				tmpID = 900480,
				configId = 900480,
				skinId = 401520,
				id = 2,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 20,
					air = 0,
					antiaircraft = 200,
					torpedo = 200,
					durability = 50000,
					reload = 200,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 150670,
						level = 10
					},
					{
						id = 150680,
						level = 10
					},
					{
						id = 150690,
						level = 10
					},
					{
						id = 30392,
						level = 10
					}
				}
			},
			{
				tmpID = 900481,
				configId = 900481,
				skinId = 401090,
				id = 3,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 20,
					air = 0,
					antiaircraft = 200,
					torpedo = 200,
					durability = 50000,
					reload = 200,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 150650,
						level = 10
					},
					{
						id = 150660,
						level = 10
					},
					{
						id = 23022,
						level = 10
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900482,
				configId = 900482,
				skinId = 407040,
				id = 1,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 500,
					air = 500,
					antiaircraft = 250,
					torpedo = 0,
					durability = 50000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 150750,
						level = 10
					},
					{
						id = 150760,
						level = 10
					},
					{
						id = 150770,
						level = 10
					},
					{
						id = 151,
						level = 10
					},
					{
						id = 340,
						level = 10
					},
					{
						id = 205005,
						level = 1
					},
					{
						id = 201216,
						level = 3
					}
				}
			}
		}
	}
}
