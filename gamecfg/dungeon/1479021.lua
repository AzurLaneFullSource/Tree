return {
	map_id = 10001,
	id = 1479021,
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
					triggerType = 1,
					waveIndex = 201,
					preWaves = {
						100
					},
					triggerParams = {
						timeout = 4
					}
				},
				{
					triggerType = 1,
					waveIndex = 202,
					preWaves = {
						101,
						102
					},
					triggerParams = {
						timeout = 6
					}
				},
				{
					triggerType = 1,
					waveIndex = 203,
					preWaves = {},
					triggerParams = {
						timeout = 33
					}
				},
				{
					triggerType = 1,
					waveIndex = 204,
					preWaves = {},
					triggerParams = {
						timeout = 44
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 14300101,
							delay = 0,
							corrdinate = {
								5,
								0,
								60
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 0,
							corrdinate = {
								-5,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 0,
							corrdinate = {
								5,
								0,
								40
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 0,
							corrdinate = {
								-5,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300102,
							delay = 2,
							corrdinate = {
								-5,
								0,
								35
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300102,
							delay = 2,
							corrdinate = {
								-5,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						201
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 14300104,
							reinforceDelay = 1,
							delay = 0,
							corrdinate = {
								0,
								0,
								50
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 14300101,
							delay = 0,
							corrdinate = {
								5,
								0,
								40
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 0,
							corrdinate = {
								5,
								0,
								60
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300102,
							delay = 0,
							corrdinate = {
								-5,
								0,
								25
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300102,
							delay = 0,
							corrdinate = {
								-5,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 103,
					conditionType = 0,
					preWaves = {
						101,
						102
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 14300103,
							delay = 0,
							corrdinate = {
								-5,
								0,
								60
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 0,
							corrdinate = {
								25,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 0.5,
							corrdinate = {
								25,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 1,
							corrdinate = {
								25,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 1.5,
							corrdinate = {
								25,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 2,
							corrdinate = {
								25,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 2.5,
							corrdinate = {
								25,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 3,
							corrdinate = {
								25,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 3.5,
							corrdinate = {
								25,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 4,
							corrdinate = {
								25,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 4.5,
							corrdinate = {
								25,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 104,
					conditionType = 1,
					preWaves = {
						202
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 14300104,
							reinforceDelay = 1,
							delay = 0,
							corrdinate = {
								0,
								0,
								50
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300103,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 14300102,
							delay = 0,
							corrdinate = {
								5,
								0,
								60
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300102,
							delay = 0,
							corrdinate = {
								5,
								0,
								40
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 0,
							corrdinate = {
								25,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 0.5,
							corrdinate = {
								25,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 1,
							corrdinate = {
								25,
								0,
								70
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 1.5,
							corrdinate = {
								25,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 2,
							corrdinate = {
								25,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 14300101,
							delay = 2.5,
							corrdinate = {
								25,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 5,
					waveIndex = 400,
					preWaves = {
						103,
						104
					},
					triggerParams = {
						bgm = "story-masazhusai"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 1201,
					conditionType = 0,
					preWaves = {
						400
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 14300001,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-2,
								0,
								55
							},
							bossData = {
								hpBarNum = 100,
								icon = "sairen"
							},
							buffList = {
								8753,
								8782,
								8786,
								8979
							},
							phase = {
								{
									switchType = 2,
									switchTo = 2,
									index = 0,
									switchParam = 0.3,
									setAI = 20006,
									addWeapon = {},
									removeWeapon = {}
								},
								{
									switchParam = 1.5,
									switchTo = 3,
									index = 2,
									switchType = 1,
									setAI = 70093,
									addBuff = {
										8699
									},
									addWeapon = {},
									removeWeapon = {},
									removeBuff = {
										8754,
										8755,
										8756,
										8757,
										8758,
										8759,
										8782
									}
								},
								{
									switchParam = 999,
									switchTo = 1,
									index = 3,
									switchType = 1,
									setAI = 10001,
									addWeapon = {
										730008
									},
									addBuff = {
										8783
									},
									removeWeapon = {}
								}
							}
						},
						{
							monsterTemplateID = 14300002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-15,
								0,
								46
							},
							buffList = {
								8749
							},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 3
								},
								{
									index = 1,
									switchParam = 999,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										730001
									},
									removeWeapon = {}
								}
							}
						},
						{
							monsterTemplateID = 14300002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-15,
								0,
								64
							},
							buffList = {
								8749
							},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 3
								},
								{
									index = 1,
									switchParam = 999,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										730001
									},
									removeWeapon = {}
								}
							}
						},
						{
							monsterTemplateID = 14300002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-7,
								0,
								36
							},
							buffList = {
								8749
							},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 0.5
								},
								{
									index = 1,
									switchParam = 999,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										730002
									},
									removeWeapon = {}
								}
							}
						},
						{
							monsterTemplateID = 14300002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								-7,
								0,
								74
							},
							buffList = {
								8749
							},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 0.5
								},
								{
									index = 1,
									switchParam = 999,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										730003
									},
									removeWeapon = {}
								}
							}
						},
						{
							monsterTemplateID = 14300002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								3,
								0,
								38
							},
							buffList = {
								8749
							},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 3
								},
								{
									index = 1,
									switchParam = 999,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										730004
									},
									removeWeapon = {}
								}
							}
						},
						{
							monsterTemplateID = 14300002,
							moveCast = true,
							delay = 0,
							corrdinate = {
								3,
								0,
								72
							},
							buffList = {
								8749
							},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 4
								},
								{
									index = 1,
									switchParam = 999,
									switchTo = 2,
									switchType = 1,
									addWeapon = {
										730004
									},
									removeWeapon = {}
								}
							}
						}
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					preWaves = {
						1201
					},
					triggerParams = {}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900294,
				configId = 900294,
				skinId = 900294,
				id = 1,
				level = 120,
				equipment = {},
				properties = {
					cannon = 100,
					air = 0,
					antiaircraft = 0,
					torpedo = 0,
					durability = 9999999,
					reload = 100,
					armor = 0,
					dodge = 90,
					speed = 40,
					luck = 0,
					hit = 150
				},
				skills = {
					{
						id = 8785,
						level = 1
					}
				}
			}
		}
	}
}
