///////////////////////////////////////////////////////////
//  UserInteface.h
//  Implementation of the Class UserInteface
//  Created on:      20-maj-2017 08:53:04
//  Original author: au288681
///////////////////////////////////////////////////////////

#if !defined(EA_3929C698_D918_4faa_A2C9_25238069C926__INCLUDED_)
#define EA_3929C698_D918_4faa_A2C9_25238069C926__INCLUDED_

#include "CollectNeuronDataThread.h"
#include "Configuration.h"
#include "StimulateNeuronThread.h"

class UserInterface
{

public:
	UserInterface();
	virtual ~UserInterface();
	void run();

private:
	void init(void);
	Configuration *m_Configuration;
	StimulateNeuronThread *m_StimulateNeuronThread;
	CollectNeuronDataThread *m_CollectNeuronDataThread;

	// Tests
	void testCollectNeuronData(void);

};
#endif // !defined(EA_3929C698_D918_4faa_A2C9_25238069C926__INCLUDED_)
