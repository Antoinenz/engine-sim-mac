#ifndef ATG_ENGINE_SIM_VEHICLE_H
#define ATG_ENGINE_SIM_VEHICLE_H

#include "scs.h"

class Vehicle {
    public:
        struct Parameters {
            double mass;
            double dragCoefficient;
            double crossSectionArea;
            double diffRatio;
            double tireRadius;
            double rollingResistance;
        };

    public:
        Vehicle();
        ~Vehicle();

        void initialize(const Parameters &params);
        void update(double dt);
        void addToSystem(atg_scs::RigidBodySystem *system, atg_scs::RigidBody *rotatingMass);
        inline double getMass() const { return m_mass; }
        inline double getRollingResistance() const { return m_rollingResistance; }
        inline double getDragCoefficient() const { return m_dragCoefficient; }
        inline double getCrossSectionArea() const { return m_crossSectionArea; }
        inline double getDiffRatio() const { return m_diffRatio; }
        inline double getTireRadius() const { return m_tireRadius; }
        double getSpeed() const;
        inline void setBrake(double brake) { m_brake = brake; }
        inline double getBrake() const { return m_brake; }
        inline double getBrakeForce() const { return m_brake * m_maxBrakeForce; }
        inline double getTravelledDistance() const { return m_travelledDistance; }
        inline void resetTravelledDistance() { m_travelledDistance = 0; }
        double linearForceToVirtualTorque(double force) const;

    protected:
        atg_scs::RigidBody *m_rotatingMass;

        double m_mass;
        double m_dragCoefficient;
        double m_crossSectionArea;
        double m_diffRatio;
        double m_tireRadius;
        double m_travelledDistance;
        double m_rollingResistance;

        // Brake pedal position [0, 1] and the force applied at full pedal
        double m_brake;
        double m_maxBrakeForce;
};

#endif /* ATG_ENGINE_SIM_VEHICLE_H */
