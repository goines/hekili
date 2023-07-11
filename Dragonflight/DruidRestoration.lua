-- DruidRestoration.lua
-- December 2022

if UnitClassBase( "player" ) ~= "DRUID" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 105 )

spec:RegisterResource( Enum.PowerType.Mana )
spec:RegisterResource( Enum.PowerType.Energy )
spec:RegisterResource( Enum.PowerType.ComboPoints )
spec:RegisterResource( Enum.PowerType.LunarPower )
spec:RegisterResource( Enum.PowerType.Rage )

spec:RegisterTalents( {
    -- Druid Talents
    astral_influence           = { 82210, 197524, 2 }, -- Increases the range of all of your abilities by $?a16949[${$s1+$137011s7}]?a137010[${$s1+$137010s5}][$s1] yards.
    cyclone                    = { 82213, 33786 , 1 }, -- Tosses the enemy target into the air, disorienting them but making them invulnerable for up to $d. Only one target can be affected by your Cyclone at a time.
    feline_swiftness           = { 82239, 131768, 2 }, -- Increases your movement speed by $s1%.
    forestwalk                 = { 92229, 400129, 2 }, -- Casting Regrowth increases your movement speed and healing received by $400126s1% for $s2 sec.
    frenzied_regeneration      = { 82220, 22842 , 1 }, -- Heals you for $o1% health over $d$?s301768[, and increases healing received by $301768s1%][].
    gale_winds                 = { 92228, 400142, 1 }, -- Increases Typhoon's radius by $s1% and its range by $s2 yds.
    heart_of_the_wild          = { 82231, 319454, 1 }, -- Abilities not associated with your specialization are substantially empowered for $d.$?!s137013[; Balance: Magical damage increased by $s1%.][]$?!s137011[; Feral: Physical damage increased by $s4%.][]$?!s137010[; Guardian: Bear Form gives an additional $s7% Stamina, multiple uses of Ironfur may overlap, and Frenzied Regeneration has ${$s9+1} charges.][]$?!s137012[; Restoration: Healing increased by $s10%, and mana costs reduced by $s12%.][]
    hibernate                  = { 82211, 2637  , 1 }, -- Forces the enemy target to sleep for up to $d.  Any damage will awaken the target.  Only one target can be forced to hibernate at a time.  Only works on Beasts and Dragonkin.
    improved_barkskin          = { 82219, 327993, 1 }, -- Barkskin's duration is increased by ${$s1/1000} sec.
    improved_rejuvenation      = { 82240, 231040, 1 }, -- Rejuvenation's duration is increased by ${$m1/1000} sec.
    improved_stampeding_roar   = { 82230, 288826, 1 }, -- Cooldown reduced by ${$m1/-1000} sec.
    improved_sunfire           = { 93714, 231050, 1 }, -- Sunfire now applies its damage over time effect to all enemies within $164815A2 yards.
    improved_swipe             = { 82226, 400158, 1 }, -- Increases $?s202028[Brutal Slash][Swipe] damage by $s1%.
    incapacitating_roar        = { 82237, 99    , 1 }, -- Shift into Bear Form and invoke the spirit of Ursol to let loose a deafening roar, incapacitating all enemies within $A1 yards for $d. Damage will cancel the effect.
    incessant_tempest          = { 92228, 400140, 1 }, -- Reduces the cooldown of Typhoon by ${$m1/-1000} sec.
    innervate                  = { 82243, 29166 , 1 }, -- Infuse a friendly healer with energy, allowing them to cast spells without spending mana for $d.$?s326228[; If cast on somebody else, you gain the effect at $326228s1% effectiveness.][]
    ironfur                    = { 82227, 192081, 1 }, -- Increases armor by ${$s1*$AGI/100} for $d.$?a231070[ Multiple uses of this ability may overlap.][]
    killer_instinct            = { 82225, 108299, 2 }, -- Physical damage and Armor increased by $s1%.
    lycaras_teachings          = { 82233, 378988, 3 }, -- You gain $s1% of a stat while in each form:; No Form: Haste; Cat Form: Critical Strike; Bear Form: Versatility; Moonkin Form: Mastery
    maim                       = { 82221, 22570 , 1 }, -- Finishing move that causes Physical damage and stuns the target. Damage and duration increased per combo point:;    1 point  : ${$s2*1} damage, 1 sec;    2 points: ${$s2*2} damage, 2 sec;    3 points: ${$s2*3} damage, 3 sec;    4 points: ${$s2*4} damage, 4 sec;    5 points: ${$s2*5} damage, 5 sec
    mass_entanglement          = { 82242, 102359, 1 }, -- Roots the target and all enemies within $A1 yards in place for $d. Damage may interrupt the effect. Usable in all shapeshift forms.
    matted_fur                 = { 82236, 385786, 1 }, -- When you use Barkskin or Survival Instincts, absorb $<shield> damage for $280165d.
    mighty_bash                = { 82237, 5211  , 1 }, -- Invokes the spirit of Ursoc to stun the target for $d. Usable in all shapeshift forms.
    natural_recovery           = { 82206, 377796, 2 }, -- Healing done and healing taken increased by $s1%.
    natures_vigil              = { 82244, 124974, 1 }, -- For $d, $?s137012[all single-target healing also damages a nearby enemy target for $s3% of the healing done][all single-target damage also heals a nearby friendly target for $s3% of the damage done].
    nurturing_instinct         = { 82214, 33873 , 2 }, -- Magical damage and healing increased by $s1%.
    primal_fury                = { 82238, 159286, 1 }, -- When you critically strike with an attack that generates a combo point, you gain an additional combo point.; Damage over time cannot trigger this effect.
    protector_of_the_pack      = { 82245, 378986, 1 }, -- $?s137012[Store $s1% of your effective healing, up to $<cap>. Your next Moonfire consumes all stored healing to increase its damage dealt.][Store $s1% of your damage, up to $<cap2>. Your next Regrowth consumes all stored damage to increase its healing.]
    rake                       = { 82199, 1822  , 1 }, -- Rake the target for $s1 Bleed damage and an additional $155722o1 Bleed damage over $155722d.$?s48484[ Reduces the target's movement speed by $58180s1% for $58180d.][]$?a231052[ ; While stealthed, Rake will also stun the target for $163505d and deal $s4% increased damage.][]$?a405834[ ; While stealthed, Rake will also stun the target for $163505d and deal $s4% increased damage.][]; Awards $s2 combo $lpoint:points;.
    rejuvenation               = { 82217, 774   , 1 }, -- Heals the target for $o1 over $d.$?s155675[; You can apply Rejuvenation twice to the same target.][]$?s33891[; Tree of Life: Healing increased by $5420s5% and Mana cost reduced by $5420s4%.][]
    renewal                    = { 82232, 108238, 1 }, -- Instantly heals you for $s1% of maximum health. Usable in all shapeshift forms.
    rip                        = { 82222, 1079  , 1 }, -- Finishing move that causes Bleed damage over time. Lasts longer per combo point.;    1 point  : ${$o1*2} over ${$d*2} sec;    2 points: ${$o1*3} over ${$d*3} sec;    3 points: ${$o1*4} over ${$d*4} sec;    4 points: ${$o1*5} over ${$d*5} sec;    5 points: ${$o1*6} over ${$d*6} sec
    rising_light_falling_night = { 82207, 417712, 1 }, -- Increases your damage and healing by $417714s1% during the day.; Increases your Versatility by $417715s1% during the night.
    skull_bash                 = { 82224, 106839, 1 }, -- You charge and bash the target's skull, interrupting spellcasting and preventing any spell in that school from being cast for $93985d.
    soothe                     = { 82229, 2908  , 1 }, -- Soothes the target, dispelling all enrage effects.
    stampeding_roar            = { 82234, 106898, 1 }, -- Shift into Bear Form and let loose a wild roar, increasing the movement speed of all friendly players within $A1 yards by $s1% for $d.
    sunfire                    = { 82208, 93402 , 1 }, -- A quick beam of solar light burns the enemy for $164815s1 Nature damage and then an additional $164815o2 Nature damage over $164815d$?s231050[ to the primary target and all enemies within $164815A2 yards][].$?s137013[; Generates ${$m3/10} Astral Power.][]
    swiftmend                  = { 82216, 18562 , 1 }, -- Consumes a Regrowth, Wild Growth, or Rejuvenation effect to instantly heal an ally for $s1.$?a383192[; Swiftmend heals the target for $383193o1 over $383193d.][]
    thick_hide                 = { 82228, 16931 , 2 }, -- Reduces all damage taken by $s1%.
    thrash                     = { 82223, 106832, 1 }, -- Thrash all nearby enemies, dealing immediate physical damage and periodic bleed damage. Damage varies by shapeshift form.
    tiger_dash                 = { 82198, 252216, 1 }, -- Shift into Cat Form and increase your movement speed by $s1%, reducing gradually over $d.
    tireless_pursuit           = { 82197, 377801, 1 }, -- For ${$s1/1000} sec after leaving Cat Form or Travel Form, you retain up to $s2% movement speed.
    typhoon                    = { 82209, 132469, 1 }, -- Blasts targets within $61391a1 yards in front of you with a violent Typhoon, knocking them back and reducing their movement speed by $61391s3% for $61391d. Usable in all shapeshift forms.
    ursine_vigor               = { 82235, 377842, 2 }, -- For $340541d after shifting into Bear Form, your health and armor are increased by $s1%.
    ursols_vortex              = { 82242, 102793, 1 }, -- Conjures a vortex of wind for $d at the destination, reducing the movement speed of all enemies within $A1 yards by $s1%. The first time an enemy attempts to leave the vortex, winds will pull that enemy back to its center.  Usable in all shapeshift forms.
    verdant_heart              = { 82218, 301768, 1 }, -- Frenzied Regeneration and Barkskin increase all healing received by $s1%.
    wellhoned_instincts        = { 82246, 377847, 2 }, -- When you fall below $s2% health, you cast Frenzied Regeneration, up to once every $s1 sec.
    wild_charge                = { 82198, 102401, 1 }, -- Fly to a nearby ally's position.
    wild_growth                = { 82241, 48438 , 1 }, -- Heals up to $s2 injured allies within $A1 yards of the target for $o1 over $d. Healing starts high and declines over the duration.$?s33891[; Tree of Life: Affects $33891s3 additional $ltarget:targets;.][]

    -- Restoration Talents
    abundance                  = { 82052, 207383, 1 }, -- For each Rejuvenation you have active, Regrowth's cost is reduced by $207640s1% and critical effect chance is increased by $207640s2%.
    adaptive_swarm             = { 82067, 391888, 1 }, -- Command a swarm that heals $391891o1 or deals $391889o1 Shadow damage over $391889d to a target, and increases the effectiveness of your periodic effects on them by $391891s2%.; Upon expiration, finds a new target, preferring to alternate between friend and foe up to $s1 times.
    budding_leaves             = { 82072, 392167, 2 }, -- Lifebloom's healing is increased by ${$s1}.1% each time it heals, up to $s2%. Also increases Lifebloom's final bloom amount by $s3%.
    cenarion_ward              = { 82052, 102351, 1 }, -- Protects a friendly target for $d. Any damage taken will consume the ward and heal the target for $102352o1 over $102352d.
    cenarius_guidance          = { 82063, 393371, 1 }, -- $@spellicon33891 $@spellname5420; During Incarnation: Tree of Life, you gain Clearcasting every $393418t sec. The cooldown of Incarnation: Tree of Life is reduced by ${$393381s2/-1000}.1 sec when Lifebloom blooms and ${$393381s1/-1000}.1 sec when Regrowth's initial heal critically strikes.; $@spellicon391528 $@spellname391528; Convoke the Spirits' cooldown is reduced by ${($abs($393374s4)/120000)*100}% and its duration and number of spells cast is reduced by $393374s1%. Convoke the Spirits has an increased chance to use an exceptional spell or ability.
    circle_of_life_and_death   = { 82074, 391969, 1 }, -- Your damage over time effects deal their damage in $s1% less time, and your healing over time effects in $s2% less time.
    convoke_the_spirits        = { 82064, 391528, 1 }, -- Call upon the Night Fae for an eruption of energy, channeling a rapid flurry of $s2 Druid spells and abilities over $d.$?s391538[ Chance to use an exceptional spell or ability is increased.][]; You will cast $?a24858|a197625[Starsurge, Starfall,]?a768[Ferocious Bite, Shred,]?a5487[Mangle, Ironfur,][Wild Growth, Swiftmend,] Moonfire, Wrath, Regrowth, Rejuvenation, Rake, and Thrash on appropriate nearby targets, favoring your current shapeshift form.
    cultivation                = { 82056, 200390, 1 }, -- When Rejuvenation heals a target below $s1% health, it applies Cultivation to the target, healing them for $200389o1 over $200389d.
    deep_focus                 = { 82074, 403949, 1 }, -- When Moonfire, Rake, Rip, or Rejuvenation are active on a single target, their effects are increased $s1%.
    dreamstate                 = { 82053, 392162, 1 }, -- While channeling Tranquility, your other Druid spell cooldowns are reduced by up to ${($s1/-1000)*5} seconds.
    efflorescence              = { 82057, 145205, 1 }, -- Grows a healing blossom at the target location, restoring $81269s1 health to $?p138284[four][three] injured allies within $81269A1 yards every $81262t1 sec for $81262d. Limit 1.
    embrace_of_the_dream       = { 82070, 392124, 2 }, -- Wild Growth has a $s3% chance to momentarily shift your mind into the Emerald Dream, instantly healing all allies affected by your Rejuvenation or Regrowth for $392147s1.
    flash_of_clarity           = { 82083, 392220, 1 }, -- Clearcast Regrowths heal for an additional $s1%.
    flourish                   = { 82079, 197721, 1 }, -- Extends the duration of all of your heal over time effects on friendly targets within $A1 yards by $s1 sec, and increases the rate of your heal over time effects by ${100*(1/(1+($m2/100))-1)}% for $d.
    forests_flow               = { 92609, 400531, 1 }, -- Nourish extends the duration of your Lifebloom, Rejuvenation, Regrowth, and Wild Growth effects on the target by $s1 sec.
    germination                = { 82071, 155675, 1 }, -- You can apply Rejuvenation twice to the same target. Rejuvenation's duration is increased by ${$s1/1000} sec.
    grove_tending              = { 82047, 383192, 1 }, -- Swiftmend heals the target for $383193o1 over $383193d.
    harmonious_blooming        = { 82065, 392256, 2 }, -- Lifebloom counts for ${$s1+1} stacks of Mastery: Harmony.
    improved_ironbark          = { 82081, 382552, 1 }, -- Ironbark's cooldown is reduced by ${$s1/-1000} sec.
    improved_natures_cure      = { 82203, 392378, 1 }, -- Nature's Cure additionally removes all Curse and Poison effects.
    improved_regrowth          = { 82055, 231032, 1 }, -- Regrowth's initial heal has a $s1% increased chance for a critical effect if the target is already affected by Regrowth.
    improved_wild_growth       = { 82045, 328025, 1 }, -- Wild Growth heals $s1 additional $ltarget:targets;.
    incarnation                = { 82064, 33891 , 1 }, -- Shapeshift into the Tree of Life, increasing healing done by $5420s1%, increasing armor by $5420s3%, and granting protection from Polymorph effects. Functionality of Rejuvenation, Wild Growth, Regrowth, and Entangling Roots is enhanced.; Lasts $117679d. You may shapeshift in and out of this form for its duration.
    incarnation_tree_of_life   = { 82064, 33891 , 1 }, -- Shapeshift into the Tree of Life, increasing healing done by $5420s1%, increasing armor by $5420s3%, and granting protection from Polymorph effects. Functionality of Rejuvenation, Wild Growth, Regrowth, and Entangling Roots is enhanced.; Lasts $117679d. You may shapeshift in and out of this form for its duration.
    inner_peace                = { 82053, 197073, 1 }, -- Reduces the cooldown of Tranquility by ${$m1/-1000} sec.; While channeling Tranquility, you take $740s5% reduced damage and are immune to knockbacks.
    invigorate                 = { 82078, 392160, 1 }, -- Refreshes the duration of your active Lifebloom and Rejuvenation effects on the target and causes them to complete $s1% faster.
    ironbark                   = { 82082, 102342, 1 }, -- The target's skin becomes as tough as Ironwood, reducing damage taken by $s1%$?a197061[ and increasing healing from your heal over time effects by $s2%][] for $d.$?a392116[; Allies protected by your Ironbark also receive $392116s1% of the healing from each of your active Rejuvenations.][]
    lifebloom                  = { 82049, 33763 , 1 }, -- Heals the target for $o1 over $d. When Lifebloom expires or is dispelled, the target is instantly healed for $33778s1.; May be active on $?s338831[two targets][one target] at a time.
    luxuriant_soil             = { 82068, 392315, 2 }, -- Rejuvenation healing has a ${$s1}.1% chance to create a new Rejuvenation on a nearby target.
    moonkin_form               = { 91042, 197625, 1 }, -- Shapeshift into $?s114301[Astral Form][Moonkin Form], increasing the damage of your spells by $s7% and your armor by $m3%, and granting protection from Polymorph effects.; The act of shapeshifting frees you from movement impairing effects.
    natures_splendor           = { 82051, 392288, 1 }, -- The healing bonus to Regrowth from Nature's Swiftness is increased by $s1%.
    natures_swiftness          = { 82050, 132158, 1 }, -- Your next Regrowth, Rebirth, or Entangling Roots is instant, free, castable in all forms, and heals for an additional $s2%.
    nourish                    = { 82043, 50464 , 1 }, -- Heals a friendly target for $s1.  Receives $s2% bonus from $@spellname77495.
    nurturing_dormancy         = { 82076, 392099, 1 }, -- When your Rejuvenation heals a full health target, its duration is increased by $s1 sec, up to a maximum total increase of $s2 sec per cast.
    omen_of_clarity            = { 82084, 113043, 1 }, -- Your healing over time from Lifebloom has a $s1% chance to cause a Clearcasting state, making your next $?a155577[${$155577m1+1} Regrowths][Regrowth] cost no mana.
    overgrowth                 = { 82061, 203651, 1 }, -- Apply Lifebloom, Rejuvenation, Wild Growth, and Regrowth's heal over time effect to an ally.
    passing_seasons            = { 82051, 382550, 1 }, -- Nature's Swiftness's cooldown is reduced by ${$s1/-1000} sec.
    photosynthesis             = { 82073, 274902, 1 }, -- While your Lifebloom is on yourself, your periodic heals heal $s1% faster.; While your Lifebloom is on an ally, your periodic heals on them have a $s2% chance to cause it to bloom.
    power_of_the_archdruid     = { 82077, 392302, 1 }, -- Wild Growth has a $h% chance to cause your next Rejuvenation or Regrowth to apply to $s1 additional $Lally:allies; within $189877s1 yards of the target.
    rampant_growth             = { 82058, 404521, 1 }, -- Regrowth's healing over time is increased by $s1%, and it also applies to the target of your Lifebloom.
    reforestation              = { 82069, 392356, 1 }, -- Every $s1 casts of Swiftmend grants you Incarnation: Tree of Life for $s2 sec.
    regenerative_heartwood     = { 82075, 392116, 1 }, -- Allies protected by your Ironbark also receive $s1% of the healing from each of your active Rejuvenations and Ironbark's duration is increased by ${$s2/1000} sec.
    regenesis                  = { 82062, 383191, 2 }, -- Rejuvenation healing is increased by up to $s1%, and Tranquility healing is increased by up to $s2%, healing for more on low-health targets.
    soul_of_the_forest         = { 82059, 158478, 1 }, -- Swiftmend increases the healing of your next Regrowth or Rejuvenation by $114108s1%, or your next Wild Growth by $114108s2%.
    spring_blossoms            = { 82061, 207385, 1 }, -- Each target healed by Efflorescence is healed for an additional $207386o1 over $207386d.
    starfire                   = { 91040, 197628, 1 }, -- Call down a burst of energy, causing $s1 Arcane damage to the target, and ${$m1*$m2/100} Arcane damage to all other enemies within $A1 yards. Deals reduced damage beyond $s3 targets.
    starsurge                  = { 82200, 197626, 1 }, -- Launch a surge of stellar energies at the target, dealing $s1 Astral damage.
    stonebark                  = { 82081, 197061, 1 }, -- Ironbark increases healing from your heal over time effects by $s1%.
    tranquil_mind              = { 92674, 403521, 1 }, -- Increases Omen of Clarity's chance to activate Clearcasting to $s3% and Clearcasting can stack $s1 additional time.
    tranquility                = { 82054, 740   , 1 }, -- Heals all allies within $a2 yards for ${$157982s1*5} over $d. Each heal heals the target for another $157982o2 over $157982d, stacking.; Healing increased by $s3% when not in a raid.
    unbridled_swarm            = { 82066, 391951, 1 }, -- Adaptive Swarm has a $s1% chance to split into two Swarms each time it jumps.
    undergrowth                = { 82077, 392301, 1 }, -- You may Lifebloom two targets at once, but Lifebloom's healing is reduced by $s1%.
    unstoppable_growth         = { 82080, 382559, 2 }, -- Wild Growth's healing falls off $s1% less over time.
    verdancy                   = { 82060, 392325, 1 }, -- When Lifebloom blooms, up to $s1 targets within your Efflorescence are healed for $392329s1.
    verdant_infusion           = { 82079, 392410, 1 }, -- Swiftmend no longer consumes a heal over time effect, and extends the duration of your heal over time effects on the target by $s1 sec.
    waking_dream               = { 82046, 392221, 1 }, -- Ysera's Gift now heals every ${$s2/1000} sec and its healing is increased by $s1% for each of your active Rejuvenations.
    wild_synthesis             = { 92609, 400533, 1 }, -- Regrowth decreases the cast time of your next Nourish by $400534s1% and causes it to receive an additional $400534s2% bonus from $@spellname77495. ; Stacks up to $s1 times.
    yseras_gift                = { 82048, 145108, 1 }, -- Heals you for $s1% of your maximum health every $t1 sec. If you are at full health, an injured party or raid member will be healed instead.$?a392221[; Healing is increased by $392221s1% for each of your active Rejuvenations.][]
} )


-- PvP Talents
spec:RegisterPvpTalents( {
    deep_roots          = 700 , -- (233755) Increases the amount of damage required to cancel your Entangling Roots or Mass Entanglement by 250%.
    disentanglement     = 59  , -- (233673) Efflorescence removes all snare effects from friendly targets when it heals.
    early_spring        = 1215, -- (203624) Wild Growth is now instant cast, and when you heal 6 allies with Wild Growth you gain Full Bloom. This effect has a 30 sec cooldown. Full Bloom Your next Wild Growth applies Lifebloom to all targets at 100% effectiveness. Lasts for 30 sec.
    entangling_bark     = 692 , -- (247543) Ironbark now also grants the target Nature's Grasp, rooting the first 2 melee attackers for 8 sec.
    focused_growth      = 835 , -- (203553) Reduces the mana cost of your Lifebloom by 8%, and your Lifebloom also applies Focused Growth to the target, increasing Lifebloom's healing by 8%. Stacks up to 3 times.
    high_winds          = 838 , -- (200931) Cyclone leaves the target reeling, reducing their damage and healing by 30% for 4 sec.
    keeper_of_the_grove = 5387, -- (353114) Tranquility protects you from all harm while it is channeled, and its healing is increased by 100%.
    malornes_swiftness  = 5514, -- (236147) Your Travel Form movement speed while within a Battleground or Arena is increased by 20% and you always move at 100% movement speed while in Travel Form.
    master_shapeshifter = 3048, -- (289237) Your Guardian, Balance or Feral Affinity is amplified granting an additional effect. Guardian Affinity Chance to be critically hit by melee attacks reduced by 10% while in Bear Form.  Balance Affinity After you enter Moonkin Form, the cast time of your Wrath and Starfire is reduced by 30% and their damage is increased by 20% for 10 sec.  Feral Affinity While in Cat Form, your bleed damage is increased by 30%.
    precognition        = 5504, -- (377360) If an interrupt is used on you while you are not casting, gain 15% Haste and become immune to crowd control, interrupt, and cast pushback effects for 5 sec.
    reactive_resin      = 691 , -- (203399) Casting Rejuvenation grants the target 2 charges of Reactive Resin. Reactive Resin will heal the target for 5,024 after taking a melee critical strike, and increase the duration of Rejuvenation by 2.5 sec.
    thorns              = 697 , -- (305497) Sprout thorns for 12 sec on the friendly target. When victim to melee attacks, thorns deals 7,667 Nature damage back to the attacker. Attackers also have their movement speed reduced by 50% for 4 sec.
} )


-- Auras
spec:RegisterAuras( {
    cenarion_ward = {
        id = 102351,
        duration = 30,
        max_stack = 1
    },
    cenarion_ward_hot = {
        id = 102352,
        duration = 8,
        max_stack = 1
    },
    flourish = {
        id = 197721,
        duration = 8,
        max_stack = 1
    },
    grove_tending = {
        id = 383193,
        duration = 9,
        max_stack = 1,
        copy = 279793 -- Azerite.
    },
    incarnation_tree_of_life = {
        id = 33891,
        duration = 30,
        max_stack = 1,
        copy = "incarnation"
    },
    ironbark = {
        id = 102342,
        duration = function() return talent.regenerative_heartwood.enabled and 16 or 12 end,
        max_stack = 1
    },
    lifebloom = {
        id = 33763,
        duration = 15,
        max_stack = 1,
        dot = "buff",
        copy = 290754
    },
    lifebloom_2 = {
        id = 188550,
        duration = 15,
        max_stack = 1,
        dot = "buff"
    },
    natures_swiftness = {
        id = 132158,
        duration = 3600,
        max_stack = 1,
        onRemove = function()
            setCooldown( "natures_swiftness", 60 )
        end,
    },
    natures_vigil = {
        id = 124974,
        duration = 15,
        max_stack = 1,
    },
    regrowth = {
        id = 8936,
        duration = 12,
        max_stack = 1
    },
    rejuvenation = {
        id = 774,
        duration = 12,
        max_stack = 1
    },
    rejuvenation_germination = {
        id = 155777,
        duration = 12,
        max_stack = 1
    },
    renewing_bloom = {
        id = 364686,
        duration = 8,
        max_stack = 1
    },
    tranquility = {
        id = 740,
        duration = function() return 8 * haste end,
        max_stack = 1,
    },
    tranquility_hot = {
        id = 157982,
        duration = 8,
        max_stack = 1
    },
    wild_growth = {
        id = 48438,
        duration = 7,
        max_stack = 1
    },
} )


spec:RegisterStateFunction( "break_stealth", function ()
    removeBuff( "shadowmeld" )
    if buff.prowl.up then
        setCooldown( "prowl", 6 )
        removeBuff( "prowl" )
    end
end )

-- Function to remove any form currently active.
spec:RegisterStateFunction( "unshift", function()
    if conduit.tireless_pursuit.enabled and ( buff.cat_form.up or buff.travel_form.up ) then applyBuff( "tireless_pursuit" ) end

    removeBuff( "cat_form" )
    removeBuff( "bear_form" )
    removeBuff( "travel_form" )
    removeBuff( "moonkin_form" )
    removeBuff( "travel_form" )
    removeBuff( "aquatic_form" )
    removeBuff( "stag_form" )

    if legendary.oath_of_the_elder_druid.enabled and debuff.oath_of_the_elder_druid_icd.down and talent.restoration_affinity.enabled then
        applyBuff( "heart_of_the_wild" )
        applyDebuff( "player", "oath_of_the_elder_druid_icd" )
    end
end )

-- Function to apply form that is passed into it via string.
spec:RegisterStateFunction( "shift", function( form )
    if conduit.tireless_pursuit.enabled and ( buff.cat_form.up or buff.travel_form.up ) then applyBuff( "tireless_pursuit" ) end

    removeBuff( "cat_form" )
    removeBuff( "bear_form" )
    removeBuff( "travel_form" )
    removeBuff( "moonkin_form" )
    removeBuff( "travel_form" )
    removeBuff( "aquatic_form" )
    removeBuff( "stag_form" )
    applyBuff( form )

    if form == "bear_form" and pvptalent.celestial_guardian.enabled then
        applyBuff( "celestial_guardian" )
    end
end )

spec:RegisterHook( "runHandler", function( ability )
    local a = class.abilities[ ability ]

    if not a or a.startsCombat then
        break_stealth()
    end

    if buff.ravenous_frenzy.up and ability ~= "ravenous_frenzy" then
        stat.haste = stat.haste + 0.01
        addStack( "ravenous_frenzy", nil, 1 )
    end
end )

spec:RegisterStateExpr( "lunar_eclipse", function ()
    return eclipse.wrath_counter
end )

spec:RegisterStateExpr( "solar_eclipse", function ()
    return eclipse.starfire_counter
end )


-- Tier 30
spec:RegisterGear( "tier30", 202518, 202516, 202515, 202514, 202513 )
-- 2 pieces (Restoration) : Rejuvenation and Lifebloom healing increased by 12%. Regrowth healing over time increased by 50%.
-- 4 pieces (Restoration) : Flourish increases the rate of your heal over time effects by 30% for an additional 16 sec after it ends. Verdant Infusion causes your Swiftmend target to gain 15% increased healing from you for 6 sec.


-- Abilities
spec:RegisterAbilities( {
    -- Protects a friendly target for 30 sec. Any damage taken will consume the ward and heal the target for 11,054 over 8 sec.
    cenarion_ward = {
        id = 102351,
        cast = 0,
        cooldown = 30,
        gcd = "spell",

        spend = 0.09,
        spendType = "mana",

        talent = "cenarion_ward",
        startsCombat = false,
        texture = 132137,

        handler = function ()
            applyBuff( "cenarion_ward" )
        end,
    },

    -- Grows a healing blossom at the target location, restoring 676 health to three injured allies within 10 yards every 1.7 sec for 30 sec. Limit 1.
    efflorescence = {
        id = 145205,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.17,
        spendType = "mana",

        talent = "efflorescence",
        startsCombat = false,
        texture = 134222,

        handler = function ()
        end,
    },

    -- Extends the duration of all of your heal over time effects on friendly targets within 60 yards by 8 sec, and increases the rate of your heal over time effects by 100% for 8 sec.
    flourish = {
        id = 197721,
        cast = 0,
        cooldown = 90,
        gcd = "spell",

        talent = "flourish",
        startsCombat = false,
        texture = 538743,

        toggle = "cooldowns",

        handler = function ()
            if buff.adaptive_swarm_heal.up then buff.adaptive_swarm_heal.expires = buff.adaptive_swarm_heal.expires + 8 end
            if buff.cenarion_ward.up then buff.cenarion_ward.expires = buff.cenarion_ward.expires + 8 end
            if buff.grove_tending.up then buff.grove_tending.expires = buff.grove_tending.expires + 8 end
            if buff.lifebloom_2.up then buff.lifebloom_2.expires = buff.lifebloom_2.expires + 8 end
            if buff.lifebloom.up then buff.lifebloom.expires = buff.lifebloom.expires + 8 end
            if buff.regrowth.up then buff.regrowth.expires = buff.regrowth.expires + 8 end
            if buff.rejuvenation_germination.up then buff.rejuvenation_germination.expires = buff.rejuvenation_germination.expires + 8 end
            if buff.rejuvenation.up then buff.rejuvenation.expires = buff.rejuvenation.expires + 8 end
            if buff.renewing_bloom.up then buff.renewing_bloom.expires = buff.renewing_bloom.expires + 8 end
            if buff.tranquility_hot.up then buff.tranquility_hot.expires = buff.tranquility_hot.expires + 8 end
            if buff.wild_growth.up then buff.wild_growth.expires = buff.wild_growth.expires + 8 end
        end,
    },

    -- Shapeshift into the Tree of Life, increasing healing done by 15%, increasing armor by 120%, and granting protection from Polymorph effects. Functionality of Rejuvenation, Wild Growth, Regrowth, and Entangling Roots is enhanced. Lasts 30 sec. You may shapeshift in and out of this form for its duration.
    incarnation_tree_of_life = {
        id = 33891,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        talent = "incarnation",
        startsCombat = false,
        texture = 236157,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "incarnation_tree_of_life" )
        end,
    },

    -- Infuse a friendly healer with energy, allowing them to cast spells without spending mana for 10 sec.
    innervate = {
        id = 29166,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        talent = "innervate",
        startsCombat = false,
        texture = 136048,

        toggle = "interrupts",

        handler = function ()
            applyBuff( "innervate" )
        end,
    },

    -- Refreshes the duration of your active Lifebloom and Rejuvenation effects on the target and causes them to complete 200% faster.
    invigorate = {
        id = 392160,
        cast = 0,
        cooldown = 20,
        gcd = "spell",

        spend = 0.02,
        spendType = "mana",

        talent = "invigorate",
        startsCombat = false,
        texture = 136073,

        handler = function ()
            if buff.lifebloom_2.up then buff.lifebloom_2.expires = query_time + buff.lifebloom_2.duration end
            if buff.lifebloom.up then buff.lifebloom.expires = query_time + buff.lifebloom.duration end
            if buff.rejuvenation_germination.up then buff.rejuvenation_germination.expires = query_time + buff.rejuvenation_germination.duration end
            if buff.rejuvenation.up then buff.rejuvenation.expires = query_time + buff.rejuvenation.duration end
        end,
    },

    -- The target's skin becomes as tough as Ironwood, reducing damage taken by 20% for 12 sec.
    ironbark = {
        id = 102342,
        cast = 0,
        cooldown = 90,
        gcd = "off",

        talent = "ironbark",
        startsCombat = false,
        texture = 572025,

        toggle = "defensives",

        handler = function ()
            applyBuff( "ironbark" )
        end,
    },

    -- Heals the target for 7,866 over 15 sec. When Lifebloom expires or is dispelled, the target is instantly healed for 4,004. May be active on one target at a time. Lifebloom counts for 2 stacks of Mastery: Harmony.
    lifebloom = {
        id = 33763,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        talent = "lifebloom",
        startsCombat = false,
        texture = 134206,

        handler = function ()
            if active_dot.lifebloom_2 > 0 then applyBuff( "lifebloom" )
            elseif active_dot.lifebloom > 0 then applyBuff( "lifebloom_2" ) end
        end,
    },

    -- Cures harmful effects on the friendly target, removing all Magic, Curse, and Poison effects.
    natures_cure = {
        id = 88423,
        cast = 0,
        charges = 1,
        cooldown = 8,
        recharge = 8,
        gcd = "spell",

        spend = 0.06,
        spendType = "mana",

        startsCombat = false,
        texture = 236288,

        buff = function()
            return buff.dispellable_magic.up and "dispellable_magic" or
                buff.dispellable_curse.up and "dispellable_curse" or
                buff.dispellable_poison.up and "dispellable_poison" or "dispellable_magic"
        end,

        handler = function ()
            removeBuff( "dispellable_magic" )
            removeBuff( "dispellable_curse" )
            removeBuff( "dispellable_poison" )
        end,
    },

    -- Your next Regrowth, Rebirth, or Entangling Roots is instant, free, castable in all forms, and heals for an additional 135%.
    natures_swiftness = {
        id = 132158,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        talent = "natures_swiftness",
        startsCombat = false,
        texture = 136076,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "natures_swiftness" )
        end,
    },

    -- Heals a friendly target for 6,471. Receives triple bonus from Mastery: Harmony.
    nourish = {
        id = 50464,
        cast = 2,
        cooldown = 0,
        gcd = "spell",

        spend = 0.18,
        spendType = "mana",

        talent = "nourish",
        startsCombat = false,
        texture = 236162,

        handler = function ()
        end,
    },

    -- Apply Lifebloom, Rejuvenation, Wild Growth, and Regrowth's heal over time effect to an ally.
    overgrowth = {
        id = 203651,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        spend = 0.12,
        spendType = "mana",

        talent = "overgrowth",
        startsCombat = false,
        texture = 1408836,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "lifebloom" )
            applyBuff( "rejuvenation" )
            applyBuff( "wild_growth" )
            applyBuff( "regrowth" )
        end,
    },

    -- Heals a friendly target for 4,267 and another 1,284 over 12 sec. Tree of Life: Instant cast.
    regrowth = {
        id = 8936,
        cast = function() return buff.incarnation.up and 0 or 1.5 end,
        cooldown = 0,
        gcd = "spell",

        spend = 0.10,
        spendType = "mana",

        startsCombat = false,
        texture = 136085,

        handler = function ()
            applyBuff( "regrowth" )
        end,
    },

    -- Heals the target for 4,624 over 15 sec. Tree of Life: Healing increased by 50% and Mana cost reduced by 30%.
    rejuvenation = {
        id = 774,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return ( buff.incarnation.up and 0.7 or 1 ) * 0.05 end,
        spendType = "mana",

        talent = "rejuvenation",
        startsCombat = false,
        texture = 136081,

        handler = function ()
            applyBuff( "rejuvenation" )
        end,
    },

    -- Instantly heals you for 30% of maximum health. Usable in all shapeshift forms.
    renewal = {
        id = 108238,
        cast = 0,
        cooldown = 90,
        gcd = "off",

        talent = "renewal",
        startsCombat = false,
        texture = 136059,

        toggle = "defensives",

        handler = function ()
            gain( 0.3 * health.max, "health" )
        end,
    },

    -- Consumes a Regrowth, Wild Growth, or Rejuvenation effect to instantly heal an ally for 10,011. Swiftmend heals the target for 3,672 over 9 sec.
    swiftmend = {
        id = 18562,
        cast = 0,
        charges = 1,
        cooldown = 15,
        recharge = 15,
        gcd = "spell",

        spend = 0.10,
        spendType = "mana",

        talent = "swiftmend",
        startsCombat = false,
        texture = 134914,

        buff = function()
            return buff.regrowth.up and "regrowth" or
                buff.wild_growth.up and "wild_growth" or
                buff.renewing_bloom.up and "renewing_bloom" or
                "rejuvenation"
        end,

        handler = function ()
            if buff.regrowth.up then removeBuff( "regrowth" )
            elseif buff.wild_growth.up then removeBuff( "wild_growth" )
            elseif buff.renewing_bloom.up then removeBuff( "renewing_bloom" )
            else removeBuff( "rejuvenation" ) end
        end,
    },

    --[[ Swipe nearby enemies, inflicting Physical damage. Damage varies by shapeshift form.
    swipe = {
        id = function() return buff.cat_form.up and 106785 or
            buff.bear_form.up and 213771
            or 213764 end,
        known = 213764,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        startsCombat = false,
        texture = 134296,

        handler = function ()
            if buff.cat_form.up then gain( 1, "combo_points" ) end
        end,

        copy = { 106785, 213771, 213764 },
    }, ]]

    -- Heals all allies within 40 yards for 8,560 over 6.6 sec. Each heal heals the target for another 199 over 8 sec, stacking. Healing increased by 100% when not in a raid.
    tranquility = {
        id = 740,
        cast = function() return 8 * haste end,
        channeled = true,
        cooldown = 180,
        gcd = "spell",

        spend = 0.18,
        spendType = "mana",

        talent = "tranquility",
        startsCombat = false,
        texture = 136107,

        toggle = "defensives",

        start = function()
            applyBuff( "tranquility" )
        end,
    },

    -- Heals up to 5 injured allies within 30 yards of the target for 3,426 over 7 sec. Healing starts high and declines over the duration. Tree of Life: Affects 2 additional targets.
    wild_growth = {
        id = 48438,
        cast = 1.5,
        cooldown = 10,
        gcd = "spell",

        spend = 0.15,
        spendType = "mana",

        talent = "wild_growth",
        startsCombat = false,
        texture = 236153,

        handler = function ()
            applyBuff( "wild_growth" )
        end,
    },
} )


spec:RegisterOptions( {
    enabled = true,

    aoe = 3,

    nameplates = false,
    nameplateRange = 8,

    damage = true,
    damageDots = true,
    damageExpiration = 6,

    enhancedRecheck = true,

    package = "Restoration Druid",
} )


spec:RegisterSetting( "experimental_msg", nil, {
    type = "description",
    name = "|cFFFF0000WARNING|r:  Healer support in this addon is focused on DPS output only.  This is more useful for solo content or downtime when your healing output is less critical in a group/encounter.  Use at your own risk.",
    width = "full",
} )


spec:RegisterPack( "Restoration Druid", 20230325, [[Hekili:TVvBpQnss4FlOvYbMjHZ2azMzfMpC5Ut3gDB0PJ9Z2UbAgAnGnNFzMmsi)B)QUTB729lgZeYQBxLVqa7URQ6QR6PEBIVJ)V5VCdkd7)fxB3j2tCNn2zQ90Pp4Vm71Jy)LhrRFc9i8Li0b4Z)donlobLrIJkc)Bj5Kn0L86(y0gkPsJZtwdlZF5QCY(SFjYFLE67cR9iET)xCSN5VChzZgC5AXPR9x(pXO94KIWJjK4esgbNweIsWah)3l)W2415P4nfHXr7FDCXNl(mL0FWEYhCN8ZfHfH)kjkg2C2ly0tWgZIlc)ekRi8FeNCOMMVweUnjg(9sYH89Sd0NsqBZgdNNK4TK9WPaTM(40XhtWRJpScLDR3FzhgLKfeVniBho4fY(nfFw3YaA8Y(3t26LbNKOSXjONWJXrOv7Xg2XAuwWwqczBICa7zBTkF72XhIJJEIeXE34nXVez1BskUvzYYzxls2Ix1KU4Z)ur4F)R415zu1o(zCcO9Oed(Ch8bWBQcNqVLEgr2t334ArceK0NY3VpyfkDxRNgVhLeScJoi(0v4KuCcifpc89NyeV6nrOS8eCAWZKhjmD7a2jHPQhNF0Q8NP7qWr6aE)g4zYKib)iS6SD9B3wP4Smqqshd367dafdS78JPVFpjchSEJ3DIcoyugqYWhs7hXf36Xy63U89LKhfu(RG9K0S3t9r9GBwdgENo1(QVheRYkM(8NXb4i8bWzCHBxgm83Too654NWmhL0JeWNlTEjRJJ3tn80UOe8bejkDU3JR3m(a6RwdzITINhi)Novtj1xxrNfF0(dtSVHlvGiKqYtdEeWUqrRfuodQwIkLQwYir1LIZvhAevporkPrhqj4)xEQrBqhzMcPVGGZ96xxVheCuYJ4SuphQyVjoBC7vfSbDacHmondIL45AzEfCz396YsNF)z5KF)z50RplhyMIzK1Ly0c455rBjjyDekbVfqU3rTNSkFXyA8JGS4Gne8IzCmdYba67z8MGkAPeFRYXRx8rGboTo4G(kjnh2Mk0287VoNO7SKO7DYcaJWaHG0GGyJv0Em)nlCex)lqgx7ObI5r5xZIVtX2PKqnirfsppos1ptZPPzfGoSkpDNi6Ff9uGayWq9cREIDdssha)JQIOPdvtwAoV5558iUmOMRgBVm4MRgBVmiNRgBVmyNEZ2la6H7n8J8x6DK8kvMynhdLaSCBiOoT0iRHdKZM8pXAovv3FusAtkwHOk2IwPyCWXysuw68zwdRO6gm(yaRm76RTkJdQtjLsZRa5yvxiekuLTKJDYvVEZvYXAMso2jpZ2LavAgqRdQesj48XRNz1ooCdnwmvM(DKvWWZXgiaiuH(ZbudCNAFhljNppNtNotgrD6lR6zceo5XxxmZ2A4qQoS58jQkLucPVqoIz6aVh4(2LBSwkoDQJRpnxwAUsLWM9MP6S1vkFdnNZN1GQqfGukO1R0KwCJYn5Ln06g7X3lRbkxQNZi9xCMmna5sy1CXxlhviH5KtPMfYW03BPCzRO(et3uqdn3Xw(4wN9jGURyasTgAGGmBQ8wnnL32wCs8AsmaaUIKHRYfTb6yXeUhMJOp28juJsjmMkE4b2)ngLLqUo2Jmz2pxX1xaA5YRjOdmgLeKyW1xu2yvM6wccHoWyDEqIUqNovPREWU2C1JQJKvPINSQfER7uq1Z)H46Vz6CH1Zj8TtLw0cHfnAenmx1HQ19U7TgUVUXvX0tYgcYPiO88vE0BDMe)rz2hCBLAyeUtb8q9ryViakf3VAdpff(8zNoXVoCuDWFZ1PotPovlvhFd1IFv8juokCDGM02DKtyPtikfkVlbZQOTYa)J2sKtSaBOUHBv7X3a1oYlw3A5M0KzO)YNXjPWAQgdIJ7DJD9xcUVr02l7V83OTrhogXjzfHBPnt)DGq)UIWe8)nh09BkctJP9BhLNfFaX6d)6DOOhXPJl(8)IebVYD2pxe(jG54e27FxJT67kNcIWt4kj4ndD(6i2yu(fg)PBDkVN5fH0sPO8WFj7BS5fH3IY3NbF9lS5hvrk))A54BaQt3Q)YlEKb8jU4VSzGb(zGoJYL6xvp1arodRAI4QAMIG0QMkjXG4MHtii)LdkcB10KIqRIq(dB1DLg2u3ZFkPNDvjD5mbO09JgPRME8xeE6ufHfcY2qwPQKlVwdkhUhSbk)UZi)A7pweUaS6yNLokuu89DuyiBz9P4WIW5EfHvfiY21WQZR2MkXuhNVYl2z5J2fHFOiCc8p30iZMQcRK0dQxOXAXkch1p9pyCq1)3FU7BJQz15m0WyXnr5Ydg5YFO0N6qBZOJvw64XxF7KNep2NPrxfHECR9Z2WRspdG4IXdPOLujtgZ86izoxbjZ97IKn5kizt(UiztVcsMC8KZlzd6ILvzAAGzYryQJjwMHMixeldOebwo3l2XAMi8SPm(minYXLerAoR4ijhoM0V9py08IW7fuj8YOzurgs9BxXDh7LAKH7mCqmJ3QVg8s1s7detwPjezlMRdB6qTtZjRmyIMm0utkrkDwZrmALgM2SCLebA(eDkcA(RBOj9LMKLQFK8aSecRcPavlJMIQ1Z0lkJy1oyuNzUmQv(C6cB2iOkVTo11lcePpWBxHGvxo6wFeSRqSktiHFBc2viuLjqXVnb7kePsgi98c2BpqL5my)rfeFZz82Jki6m3EnXSCLLe9xdJ4kRbQvy(JljM(rSYKkLJ2Yr(tw1wMdXB86uS3BmJWz8BzJdusmLl(0hljCtef5js221PklbLkDUy517njVKJkIB7XJ1wAjh1w8ZfNRAPKAA4dSLmTHTnVPZcC0K68qA)k7RevN0KUXQvPzLHQkvDud3Z1JAQESxLqPMpSmOwz7IlfBBUKnS86t)yu1OURBRnqh4u8GiCz7rQY0m0J4zTS0A)0PfNs0xp(vHjCRlPgpDx)kL5XV15)r8WpQQZNLTsXSY5tnLHVrNCQg1mFRLh5rDBMzWeXCjNAMP7zLsvpgDfKAodPgBE9XUVNFavnEhzQCyZ5h06cdOUJToTCRsufskO75XWoeNZTyuxv8(29B1BE7AoU1qze)f8YdKvrte9yneLOww8QbrKMdDPU0MBWAunnVfwD7XBYosMAINaS(3Liigk7W1uTTSyX9QmOAOcRwamg4NP4v0OPTVFLXROxHcgnpyl5B7jEbz(Uww3vtGBbL00AlfXh3Ms3WQ3BUeLSAVLPg34cPnoQ2(ue21sJ9TlJMgn9UHTcdbwDnhyvrpjpODUcvAC7YPOkm2Yw4esoblBgYpx2mfft2gSprW0ci2Y)SdJKY0CPhlXqgoM1QMQA)T34YzAZeyoVJM6qX7t3GDn1I1VnChdmZCamnnyWrJ1(CJT(wmKLG(MFdZAxN5Grc4hF02aFfOk9pjHYELw))BV6oMYxKAhdB1N1oA5PMXd3qww7v118X2jdWCylpjQDlM9)KjbTOEojgX18431XSwJYuKr66pr7KtfACnt)IYZ2fN4V8xrpH2rEIWEQ))7]] )