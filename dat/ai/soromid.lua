require("dat/ai/tpl/generic.lua")
require("dat/ai/personality/patrol.lua")

-- Settings
mem.armour_run = 40
mem.armour_return = 70
mem.aggressive = true


function create ()

   -- Not too many credits.
   ai.setcredits( rnd.rnd(ai.pilot():ship():price()/300, ai.pilot():ship():price()/70) )

   -- Get refuel chance
   p = player.pilot()
   if p:exists() then
      standing = ai.getstanding( p ) or -1
      mem.refuel = rnd.rnd( 2000, 4000 )
      if standing < 20 then
         mem.refuel_no = _("\"The warriors of Sorom are not your personal refueller.\"")
      elseif standing < 70 then
         if rnd.rnd() > 0.2 then
            mem.refuel_no = _("\"The warriors of Sorom are not your personal refueller.\"")
         end
      else
         mem.refuel = mem.refuel * 0.6
      end
      -- Most likely no chance to refuel
      mem.refuel_msg = string.format( _("\"I suppose I could spare some fuel for %d credits.\""), mem.refuel )
   end

   -- Handle bribing
   if rnd.int() > 0.4 then
      mem.bribe_no = _("\"I shall especially enjoy your death.\"")
   else
      bribe_no = {
         _("\"Snivelling waste of carbon.\""),
         _("\"Money won't save you from being purged from the gene pool.\""),
         _("\"Culling you will be doing humanity a service.\""),
         _("\"We do not consort with vermin.\""),
         _("\"Who do you take us for, the Empire?\"")
      }
      mem.bribe_no = bribe_no[ rnd.rnd(1,#bribe_no) ]
   end

   mem.loiter = 3 -- This is the amount of waypoints the pilot will pass through before leaving the system

   -- Finish up creation
   create_post()
end

-- taunts
function taunt ( target, offense )

   -- Only 50% of actually taunting.
   if rnd.rnd(0,1) == 0 then
      return
   end

   -- some taunts
   if offense then
      taunts = {
         _("There is no room in this universe for scum like you!"),
         _("Culling you will be doing humanity a service."),
         _("Enjoy your last moments, worm!"),
         _("Time for a little natural selection!"),
         _("Might makes right!"),
         _("Embrace your weakness!")
      }
   else
      taunts = {
         _("Cunning, but foolish."),
         _("Ambush! Defend yourselves!"),
         _("You should have picked easier prey!"),
         _("You'll regret that!"),
         _("That was a fatal mistake!")
      }
   end

   ai.pilot():comm(target, taunts[ rnd.rnd(1,#taunts) ])
end


