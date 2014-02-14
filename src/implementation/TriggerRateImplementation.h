#ifndef l1menu_implementation_TriggerRateImplementation_h
#define l1menu_implementation_TriggerRateImplementation_h

#include "l1menu/ITriggerRate.h"
#include <vector>
#include <memory>
#include <map>

//
// Forward declarations
//
namespace l1menu
{
	class ITrigger;
	namespace implementation
	{
		class MenuRateImplementation;
	}
}


namespace l1menu
{
	namespace implementation
	{
		/** @brief Implementation of the ITriggerRate interface.
		 *
		 * @author Mark Grimes (mark.grimes@bristol.ac.uk)
		 * @date 28/Jun/2013
		 */
		class TriggerRateImplementation : public l1menu::ITriggerRate
		{
		public:
			TriggerRateImplementation( const l1menu::ITrigger& trigger, float fraction, float fractionError, float rate, float rateError, float pureFraction, float pureFractionError, float pureRate, float pureRateError );
			TriggerRateImplementation( TriggerRateImplementation&& otherTriggerRate ) noexcept; ///< Move constructor. One not implicitly generated because I have a custom destructor.
			TriggerRateImplementation& operator=( TriggerRateImplementation&& otherTriggerRate ) noexcept; ///< Move assignment. One not implicitly generated because I have a custom destructor.
			virtual ~TriggerRateImplementation();

			// Method to set parameter errors.
			void setParameterErrors( const std::string& parameterName, float errorLow, float errorHigh );


			// Methods required by the l1menu::ITriggerRate interface
			virtual const l1menu::ITriggerDescription& trigger() const;
			virtual bool parameterErrorsAreAvailable( const std::string& parameterName ) const;
			virtual const float& parameterErrorLow( const std::string& parameterName ) const;
			virtual const float& parameterErrorHigh( const std::string& parameterName ) const;
			virtual float fraction() const;
			virtual float fractionError() const;
			virtual float rate() const;
			virtual float rateError() const;
			virtual float pureFraction() const;
			virtual float pureFractionError() const;
			virtual float pureRate() const;
			virtual float pureRateError() const;
		protected:
			std::unique_ptr<l1menu::ITrigger> pTrigger_;
			std::map<std::string,float> parameterErrorsHigh_;
			std::map<std::string,float> parameterErrorsLow_;
			float fraction_;
			float fractionError_;
			float rate_;
			float rateError_;
			float pureFraction_;
			float pureFractionError_;
			float pureRate_;
			float pureRateError_;
		};


	} // end of the implementation namespace
} // end of the l1menu namespace
#endif
