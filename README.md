# Trebuchet

## Background

A trebuchet is a medieval weapon typically used during a battle or siege. It uses a heavy counterweight to propel a projectile over a great distance. Although the origins of the trebuchet are uncertain, it's thought that it was invented in China and later introduced to Europe.

At the most basic level a trebuchet is a device that converts potential energy to kinetic energy. 

This project was inspired by a Trebuchet constructed by Ross Kelly. Check out videos of it in action [here](https://www.youtube.com/watch?v=X1QU1nfKZ8E "Launching view.") and [here](https://www.youtube.com/watch?v=xD6mgKXwC2c "Side view."). The design for his Trebuchet is loosely based on the [Pennypult](https://www.kickstarter.com/projects/apptivus/pennypult-ultimate-office-toy-and-model-trebuchet) Kickstarter project. 

Some interesting background information:
- https://www.youtube.com/watch?v=9seapca1Vh0
- https://www.youtube.com/watch?v=QVO8VznqMeQ

## Physics

The payload arm is significantly longer than the counterweight arm.  [Mechanical Advantage](https://en.wikipedia.org/wiki/Mechanical_advantage) then allows the payload to achieve a much larger linear velocity. However, because the range of motion for the counterweight is smaller, it must also have a significantly larger mass. There is practical upper limit on the mass of the counterweight, which cannot fall faster than [free fall](https://en.wikipedia.org/wiki/Free_fall).

As the payload arm rotates the angle α increases because the payload experiences centripetal acceleration. The sling allows the projectile to achieve far greater linear velocity than the tip of the payload arm. The reason for this is twofold:

1. the effective length of the payload arm is extended by the length of the sling and
2. the sling can rotate freely with respect to the payload arm, centripetal acceleration resulting in rapid angular acceleration of the sling.

### Release Angle

The release angle, ψ, given as the initial angle between the projectile's trajectory and the horizontal, is important for determining the range of the projectile. In practice the release angle can be altered by adjusting the angle of the finger at the end of the payload arm.

## Physical Parameters

According to [Trebuchet Physics][trebphysics]:
- the optimal length for the payload arm is [3.75 times][trebmechanics] the length of the counterweight arm;
- the optimal length of the sling is the same as the length of the long arm of the beam;
- the counterweight should be around 100 times the mass of the projectile.

## Considerations

An effective Trebuchet should

- deliver a destructive projectile (large kinetic energy, which means maximising mass and speed);
- from a great distance.

## Model

The model we consider is detailed in a SVG diagram (`trebuchet-schematic.svg`).

![Trebuchet schematic.](https://rawgit.com/DataWookie/Trebuchet/master/trebuchet-schematic.svg "Schematic of the Trebuchet model with definitions of p
aremeters.")

Reference parameters can be tested with the [Virtual Trebuchet](http://virtualtrebuchet.com/).

## Useful References

- [Virtual Trebuchet](http://www.virtualtrebuchet.com/)
- [Optimizing the Counterweight Trebuchet](http://demonstrations.wolfram.com/OptimizingTheCounterweightTrebuchet/)
- [What affects the range of a trebuchet?](http://www.ucl.ac.uk/~zcapf71/Trebuchet%20coursework%20for%20website.pdf)
- [A Mathematical Model for a Trebuchet](http://classes.engineering.wustl.edu/2009/fall/ese251/presentations/(AAM_13)Trebuchet.pdf)
- [Trebuchet Physics][trebphysics]
- [Trebuchet Mechanics][trebmechanics] (which includes a high level of mathematical detail)
- [The Algorithmic Beauty of the Trebuchet](http://www.algobeautytreb.com/)

[trebmechanics]: http://asme.usu.edu/wp-content/uploads/2013/09/trebmath35.pdf "Trebuchet Mechanics"
[trebphysics]: http://www.real-world-physics-problems.com/trebuchet-physics.html "Trebuchet Physics"

### Elementary Analysis

An elementary analysis of a projectile with specific speed launched at an angle ψ above the horizontal will achieve a maximum range if ψ is 45°. Although this is a useful starting point when analysing a trebuchet, it is far from realistic. The problem is that the speed of the projectile is changing with time, so that a launch at 45° inclination might occur before the projectile has achieved maximum possible speed.
